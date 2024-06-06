defmodule LolAnalytics.Facts.ChampionPickedSummonerSpell.FactProcessor do
alias LolAnalytics.Facts.ChampionPickedSummonerSpell

  def process_game_at_url(url) do
    data = HTTPoison.get!(url)
    process_game_data(data.body)
  end

  defp process_game_data(data) do
    decoded_match = Poison.decode!(data, as: %LoLAPI.Model.MatchResponse{})
    participants = decoded_match.info.participants
    version = extract_game_version(decoded_match)

    participants
    |> Enum.each(fn participant = %LoLAPI.Model.Participant{} ->
      if participant.teamPosition != "" do

        attrs_spell_1 = %{
          champion_id: participant.championId,
          match_id: decoded_match.metadata.matchId,
          is_win: participant.win,
          summoner_spell_id: participant.summoner1Id,
          game_length_seconds: decoded_match.info.gameDuration,
          queue_id: decoded_match.info.queueId,
          puuid: participant.puuid,
          team_position: participant.teamPosition,
          patch_number: version
        }
        attrs_spell_2 = %{
          champion_id: participant.championId,
          match_id: decoded_match.metadata.matchId,
          is_win: participant.win,
          summoner_spell_id: participant.summoner2Id,
          game_length_seconds: decoded_match.info.gameDuration,
          queue_id: decoded_match.info.queueId,
          puuid: participant.puuid,
          team_position: participant.teamPosition,
          patch_number: version
        }
        ChampionPickedSummonerSpell.Repo.insert(attrs_spell_1)
        ChampionPickedSummonerSpell.Repo.insert(attrs_spell_2)
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
