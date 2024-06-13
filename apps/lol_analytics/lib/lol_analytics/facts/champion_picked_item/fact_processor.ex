defmodule LolAnalytics.Facts.ChampionPickedItem.FactProcessor do
  require Logger
  @behaviour LolAnalytics.Facts.FactBehaviour

  @doc """

  iex> LolAnalytics.Facts.ChampionPickedItem.FactProcessor.process_game_at_url("http://192.168.1.55:9000/ranked/EUW1_6923405153.json")
  """
  @impl true
  def process_game_at_url(url) do
    data = HTTPoison.get!(url)
    process_game_data(data.body)
  end

  defp process_game_data(data) do
    decoded_match = Poison.decode!(data, as: %LoLAPI.Model.MatchResponse{})
    participants = decoded_match.info.participants
    version = extract_game_version(decoded_match)

    Logger.info("Processing ChampionPickedItem for match #{decoded_match.metadata.matchId}")

    participants
    |> Enum.each(fn participant = %LoLAPI.Model.Participant{} ->
      if participant.teamPosition != "" do
        [:item0, :item1, :item2, :item3, :item4, :item5, :item6]
        |> Enum.with_index()
        |> Enum.map(fn {item_key, index} ->
          {index, Map.get(participant, item_key)}
        end)
        |> IO.inspect()
      end
    end)
  end

  defp extract_game_version(game_data) do
    game_data.info.gameVersion
    |> String.split(".")
    |> Enum.take(2)
    |> Enum.join(".")
  end
end
