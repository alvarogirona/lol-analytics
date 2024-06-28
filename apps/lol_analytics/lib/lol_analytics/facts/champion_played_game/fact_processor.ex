defmodule LolAnalytics.Facts.ChampionPlayedGame.FactProcessor do
  require Logger

  alias LolAnalytics.Dimensions.Match.MatchSchema
  alias LolAnalytics.Dimensions.Match.MatchRepo

  @spec process_match(%MatchSchema{}) :: :ok | {:error, String.t()}
  def process_match(match) do
    match_url = "http://192.168.1.55:9000/ranked/#{match.patch_number}/#{match.match_id}.json"

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(match_url),
         {:ok, decoded_match} <- Poison.decode(body, as: %LoLAPI.Model.MatchResponse{}) do
      process_game_data(decoded_match)
      MatchRepo.update(match, %{fact_champion_played_game_status: :processed})
      :ok
    else
      _ ->
        MatchRepo.update(match, fact_champion_played_game_status: :error_match_not_found)
        Logger.error("Could not process data from #{match_url} for ChampionPickedItem")
        {:error, "Could not process data from #{match_url}"}
    end
  end

  def process_game_data(decoded_match) do
    participants = decoded_match.info.participants
    version = extract_game_version(decoded_match)

    match =
      MatchRepo.get_or_create(%{
        match_id: decoded_match.metadata.matchId,
        patch_number: decoded_match.info.gameVersion,
        queue_id: decoded_match.info.queueId
      })

    Logger.info("Processing ChampionPlayedMatch for #{decoded_match.metadata.matchId}")

    participants
    |> Enum.each(fn participant = %LoLAPI.Model.Participant{} ->
      if participant.teamPosition != "" do
        attrs = %{
          champion_id: participant.championId,
          match_id: decoded_match.metadata.matchId,
          is_win: participant.win,
          game_length_seconds: decoded_match.info.gameDuration,
          queue_id: decoded_match.info.queueId,
          puuid: participant.puuid,
          team_position: participant.teamPosition,
          patch_number: version
        }

        LolAnalytics.Facts.ChampionPlayedGame.Repo.insert(attrs)
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
