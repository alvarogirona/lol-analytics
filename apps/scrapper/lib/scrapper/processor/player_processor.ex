defmodule Scrapper.Processor.PlayerProcessor do
  alias Calendar.ISO
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
           on_failure: :reject_and_requeue,
           qos: [
             prefetch_count: 1
           ]},
        concurrency: 1,
        rate_limiting: [
          interval: 1000 * 10,
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
  @spec handle_message(any(), Broadway.Message.t(), any()) :: Broadway.Message.t()
  def handle_message(_, message = %Broadway.Message{}, _) do
    puuid = message.data

    case LolAnalytics.Player.PlayerRepo.get_player(puuid) do
      nil ->
        :noop

      player ->
        update_player_processed(player)
    end

    match_history = LoLAPI.MatchApi.get_matches_from_player(puuid)

    case match_history do
      {:ok, matches} ->
        {
          matches
          |> Enum.each(fn match_id ->
            Scrapper.Queue.MatchQueue.queue_match(match_id)
          end)
        }

      {:err, code} ->
        {:err, code}
    end

    message
  end

  defp update_player_processed(player) do
    LolAnalytics.Player.PlayerRepo.update_player(player, %{
      :last_processed_at => DateTime.utc_now() |> DateTime.truncate(:second)
    })
  end
end
