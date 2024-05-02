defmodule Scrapper.Processor.PlayerProcessor do
  use Broadway

  def start_link(_opts) do
    Broadway.start_link(
      __MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayRabbitMQ.Producer,
           queue: "player",
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
          allowed_messages: 2
        ]
      ],
      processors: [
        default: [
          concurrency: 2
        ]
      ]
    )
  end

  @impl true
  def handle_message(_, message = %Broadway.Message{}, _) do
    puuid = message.data

    IO.inspect(puuid)

    Scrapper.Data.Api.MatchApi.get_matches_from_player(puuid)
    |> Enum.each(fn match_id ->
      IO.inspect(match_id)
      Scrapper.Queue.MatchQueue.queue_match(match_id)
    end)

    message
  end
end
