defmodule Scrapper.MatchBroadway do
  use Broadway

  alias Broadway.Message

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
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 20
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message = %Broadway.Message{}, _) do
    match_id = message.data
    IO.inspect(match_id)
    match = Scrapper.Data.Api.MatchApi.get_match_by_id(match_id)
    IO.inspect(match)
    message.data
  end
end
