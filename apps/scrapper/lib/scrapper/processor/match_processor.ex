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
          interval: 1000 * 90,
          allowed_messages: 5
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
    IO.inspect(match_id)

    match = Scrapper.Data.Api.MatchApi.get_match_by_id(match_id)

    match.metadata.participants
    |> Enum.each(fn participant ->
      Scrapper.Data.Api.MatchApi.get_matches_from_player(participant)
      |> Enum.each(fn match_id ->
        nil
        Scrapper.Queue.MatchQueue.queue_match(match_id)
      end)
    end)

    IO.inspect(match.info.participants)
    message
  end
end
