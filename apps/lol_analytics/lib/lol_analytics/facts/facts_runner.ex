defmodule LolAnalytics.Facts.FactsRunner do
  alias LolAnalytics.Facts

  def analyze_match(match) do
    get_facts()
    |> Enum.each(fn fact_runner ->
      apply(fact_runner, [match])
    end)
  end

  def get_facts() do
    [
      &Facts.ChampionPickedSummonerSpell.FactProcessor.process_match/1,
      &Facts.ChampionPlayedGame.FactProcessor.process_match/1,
      &Facts.ChampionPickedItem.FactProcessor.process_match/1
    ]
  end

  def peach(enum, fun, concurrency \\ System.schedulers_online(), timeout \\ :infinity) do
    Task.async_stream(enum, &fun.(&1), max_concurrency: concurrency, timeout: timeout)
    |> Stream.each(fn {:ok, val} -> val end)
    |> Enum.to_list()
  end
end
