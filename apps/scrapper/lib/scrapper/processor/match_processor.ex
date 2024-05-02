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
             prefetch_count: 3
           ]},
        concurrency: 1,
        rate_limiting: [
          interval: 1000 * 60,
          allowed_messages: 150
        ]
      ],
      processors: [
        default: [
          concurrency: 5
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
    Scrapper.Storage.S3MatchStorage.store_match(match_id, raw_match)

    decoded_match.metadata.participants
    |> Enum.each(fn participant ->
      case Scrapper.Data.Api.MatchApi.get_matches_from_player(participant) do
        {:ok, matches} ->
          matches
          |> Enum.each(fn match_id ->
            Scrapper.Queue.MatchQueue.queue_match(match_id)
          end)

        {:err, code} ->
          {:err, code}
      end
    end)
  end

  def process_resp({:err, code}, match_id) do
  end
end
