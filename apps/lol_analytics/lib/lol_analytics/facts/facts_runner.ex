defmodule LolAnalytics.Facts.FactsRunner do
  alias LolAnalytics.Facts

  def analyze_all_matches do
    Storage.MatchStorage.S3MatchStorage.stream_files("ranked")
    |> peach(fn %{key: path} ->
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
      &Facts.ChampionPickedSummonerSpell.FactProcessor.process_game_at_url/1,
      &Facts.ChampionPlayedGame.FactProcessor.process_game_at_url/1
    ]
  end

  def peach(enum, fun, concurrency \\ System.schedulers_online() * 2, timeout \\ :infinity) do
    Task.async_stream(enum, &fun.(&1), max_concurrency: concurrency, timeout: timeout)
    |> Stream.each(fn {:ok, val} -> val end)
    |> Enum.to_list()
  end
end
