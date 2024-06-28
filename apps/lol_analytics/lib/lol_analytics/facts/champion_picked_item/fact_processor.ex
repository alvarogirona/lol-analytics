defmodule LolAnalytics.Facts.ChampionPickedItem.FactProcessor do
  require Logger

  alias LolAnalytics.Dimensions.Match.MatchSchema
  alias LolAnalytics.Dimensions.Match.MatchRepo
  alias LolAnalytics.Facts.ChampionPickedItem.Repo

  @doc """

  iex> LolAnalytics.Facts.ChampionPickedItem.FactProcessor.process_game_at_url("http://192.168.1.55:9000/ranked/14.3.558.106/EUW1_6803789466.json")
  """
  @impl true
  def process_game_at_url(url) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(url),
         {:ok, decoded_match} <- Poison.decode(body, as: %LoLAPI.Model.MatchResponse{}) do
      process_game_data(decoded_match)
    else
      _ ->
        Logger.error("Could not process data from #{url} for ChampionPickedItem")
        {:error, "Could not process data from #{url}"}
    end
  end

  @spec process_match(%MatchSchema{}) :: :ok | {:error, String.t()}
  def process_match(match) do
    match_url = "http://192.168.1.55:9000/ranked/#{match.patch_number}/#{match.match_id}.json"

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(match_url),
         {:ok, decoded_match} <- Poison.decode(body, as: %LoLAPI.Model.MatchResponse{}) do
      process_game_data(decoded_match)
      MatchRepo.update(match, %{fact_champion_picked_item_status: :processed})
      :ok
    else
      _ ->
        MatchRepo.update(match, fact_champion_picked_item_status: :error_match_not_found)
        Logger.error("Could not process data from #{match_url} for ChampionPickedItem")
        {:error, "Could not process data from #{match_url}"}
    end
  end

  defp process_game_data(decoded_match) do
    participants = decoded_match.info.participants
    version = extract_game_version(decoded_match)

    match =
      MatchRepo.get_or_create(%{
        match_id: decoded_match.metadata.matchId,
        patch_number: decoded_match.info.gameVersion,
        queue_id: decoded_match.info.queueId
      })

    Logger.info("Processing ChampionPickedItem for match #{decoded_match.metadata.matchId}")

    participants
    |> Enum.each(fn participant = %LoLAPI.Model.Participant{} ->
      if participant.teamPosition != "" do
        [:item0, :item1, :item2, :item3, :item4, :item5, :item6]
        |> Enum.with_index()
        |> Enum.each(fn {item_key, index} ->
          item_key = Map.get(participant, item_key)

          Repo.insert(%{
            champion_id: participant.championId,
            match_id: decoded_match.metadata.matchId,
            is_win: participant.win,
            item_id: item_key,
            slot_number: index,
            game_length_seconds: decoded_match.info.gameDuration,
            queue_id: decoded_match.info.queueId,
            puuid: participant.puuid,
            team_position: participant.teamPosition,
            patch_number: version
          })
        end)
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
