defmodule LolAnalytics.Facts.ChampionPlayedGame.FactProcessor do
  require Logger

  @behaviour LolAnalytics.Facts.FactBehaviour

  @impl true
  @spec process_game_at_url(String.t()) :: none()
  def process_game_at_url(url) do
    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.get(url),
         {:ok, decoded_match} <- Poison.decode(body, as: %LoLAPI.Model.MatchResponse{}) do
      process_game_data(decoded_match)
    else
      _ -> {:error, "Could not process data from #{url}"}
    end
  end

  def process_game_data(decoded_match) do
    participants = decoded_match.info.participants
    version = extract_game_version(decoded_match)

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
