defmodule Scrapper.Consumer.MatchConsumer do
  require Logger
  use Broadway

  def start_link(_opts) do
    Broadway.start_link(
      __MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayRabbitMQ.Producer,
           queue: "match",
           connection: [
             username: "guest",
             password: "guest",
             host: "localhost"
           ],
           on_failure: :reject_and_requeue,
           qos: [
             prefetch_count: 1
           ]},
        concurrency: 1,
        rate_limiting: [
          interval: 300,
          allowed_messages: 1
        ]
      ],
      processors: [
        default: [
          concurrency: 1
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message = %Broadway.Message{}, _) do
    match_id = message.data

    resp = LoLAPI.MatchApi.get_match_by_id(match_id)
    process_resp(resp, match_id)

    message
  end

  def process_resp({:ok, raw_match}, match_id) do
    Task.start_link(fn ->
      decoded_match = Poison.decode!(raw_match, as: %LoLAPI.Model.MatchResponse{})

      match_url =
        case decoded_match.info.queueId do
          420 ->
            Logger.info("#{match_id} #{decoded_match.info.gameVersion}")

            Storage.MatchStorage.S3MatchStorage.store_match(
              match_id,
              raw_match,
              "ranked",
              "#{decoded_match.info.gameVersion}"
            )

            LolAnalytics.Dimensions.Match.MatchRepo.get_or_create(%{
              match_id: decoded_match.metadata.matchId,
              patch_number: decoded_match.info.gameVersion,
              queue_id: 420
            })

          _queue_id ->
            Storage.MatchStorage.S3MatchStorage.store_match(match_id, raw_match, "matches")
        end

      decoded_match.metadata.participants
      # |> Enum.shuffle()
      # |> Enum.take(2)
      |> Enum.each(fn participant_puuid ->
        Scrapper.Queue.PlayerQueue.enqueue_puuid(participant_puuid)
      end)
    end)
  end

  def process_resp({:err, _code}, _match_id) do
  end
end
