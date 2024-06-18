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

  def process_all_matches() do
    Task.Supervisor.async(LoLAnalytics.TaskSupervisor, fn ->
      LolAnalytics.Facts.FactsRunner.analyze_all_matches()
    end)
  end

  def get_running_processes() do
    Task.Supervisor.children(LoLAnalytics.TaskSupervisor)
  end
end
