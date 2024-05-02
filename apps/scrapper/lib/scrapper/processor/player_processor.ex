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
           on_failure: :reject,
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
  def handle_message(_, message = %Broadway.Message{}, _) do
    puuid = message.data

    resp = Scrapper.Data.Api.MatchApi.get_matches_from_player(puuid)

    case LolAnalytics.Player.PlayerRepo.get_player(puuid) do
      nil ->
        LolAnalytics.Player.PlayerRepo.insert_player(puuid)

      player ->
        player
        |> LolAnalytics.Player.PlayerRepo.update_player(%{
          :last_processed_at => DateTime.utc_now() |> DateTime.truncate(:seconds)
        })
    end

    case resp do
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

  defp update_player(nil), do: :player_not_found

  defp update_player(player) do
    LolAnalytics.Player.PlayerRepo.update_player(player, %{
      :last_processed_at => DateTime.utc_now() |> DateTime.truncate(:second)
    })
  end
end
