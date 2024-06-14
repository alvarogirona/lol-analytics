defmodule Scrapper.Processor.MatchProcessor do
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
          interval: 333 * 1,
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

        queue_id ->
          Storage.MatchStorage.S3MatchStorage.store_match(match_id, raw_match, "matches")
      end

    match = LolAnalytics.Match.MatchRepo.get_match(match_id)

    case match do
      nil ->
        LolAnalytics.Match.MatchRepo.insert_match(match_id)

      _ ->
        LolAnalytics.Match.MatchRepo.update_match(match, %{
          :processed => true,
          :match_url => match_url
        })
    end

    decoded_match.metadata.participants
    |> Enum.shuffle()
    |> Enum.take(2)
    |> Enum.each(fn participant_puuid ->
      Scrapper.Queue.PlayerQueue.queue_puuid(participant_puuid)
    end)
  end

  def process_resp({:err, _code}, _match_id) do
  end
end
