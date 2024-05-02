defmodule Scrapper.Processor.MatchProcessor do
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
           on_failure: :reject,
           qos: [
             prefetch_count: 1
           ]},
        concurrency: 1,
        rate_limiting: [
          interval: 1000 * 3,
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

    resp = Scrapper.Data.Api.MatchApi.get_match_by_id(match_id)
    process_resp(resp, match_id)

    message
  end

  def process_resp({:ok, raw_match}, match_id) do
    decoded_match = Poison.decode!(raw_match, as: %Scrapper.Api.Model.MatchResponse{})
    match_url = Scrapper.Storage.S3MatchStorage.store_match(match_id, raw_match)
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
    |> Enum.each(fn participant ->
      Scrapper.Queue.PlayerQueue.queue_player(participant)
    end)
  end

  def process_resp({:err, code}, match_id) do
  end
end
