defmodule LolAnalytics.MatchesProcessor do
  use GenServer

  @doc """
  iex> LolAnalytics.MatchesProcessor.process_for_patch "14.12.593.5894"
  """
  def process_for_patch(patch) do
    Task.Supervisor.async(LoLAnalytics.TaskSupervisor, fn ->
      LolAnalytics.Facts.FactsRunner.analyze_by_patch(patch)
    end)
  end
end
