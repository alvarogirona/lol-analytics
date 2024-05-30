defmodule LolAnalytics.Analyzer.ChampionAnalyzer do
  alias LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameSchema
  @behaviour LolAnalytics.Analyzer

  def analyze_all_matches do
    Storage.MatchStorage.S3MatchStorage.stream_files("ranked")
    |> Enum.each(fn %{key: path} ->
      IO.inspect(path)
      LolAnalytics.Analyzer.ChampionAnalyzer.analyze(:url, "http://192.168.1.55:9000/ranked/#{path}")
    end)

    # Storage.MatchStorage.S3MatchStorage.list_files("ranked")
    # |> Enum.map(& &1.key)
    # |> Enum.each(fn path ->
    #   LolAnalytics.Analyzer.ChampionAnalyzer.analyze(:url, "http://localhost:9000/ranked/#{path}")
    # end)
  end

  @doc """
  iex> LolAnalytics.Analyzer.ChampionAnalyzer.analyze(:url, "http://localhost:9000/ranked/14.9.580.2108/EUW1_6923309745.json")
  """
  @spec analyze(any(), any()) :: none()
  @impl true
  def analyze(:url, path) do
    data = HTTPoison.get!(path)
    analyze(:data, data.body)
    :ok
  end

  @impl true
  def analyze(:data, data) do
    decoded_match = Poison.decode!(data, as: %LoLAPI.Model.MatchResponse{})
    participants = decoded_match.info.participants
    version = extract_game_version(decoded_match)

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
          team_position: participant.teamPosition
        }
        LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameRepo.insert(attrs)
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
