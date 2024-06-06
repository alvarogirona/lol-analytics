defmodule LolAnalytics.Facts.FactsRunner do
  alias LolAnalytics.Facts

  def analyze_all_matches do
    Storage.MatchStorage.S3MatchStorage.stream_files("ranked")
    |> Enum.each(fn %{key: path} ->
      get_facts()
      |> Enum.each(fn fact_runner ->
        apply(fact_runner, ["http://192.168.1.55:9000/ranked/#{path}"])
      end)
    end)
  end

  def analyze_match() do
  end

  def get_facts() do
    [
      &Facts.ChampionPickedSummonerSpell.FactProcessor.process_game_at_url/1
    ]
  end
end
