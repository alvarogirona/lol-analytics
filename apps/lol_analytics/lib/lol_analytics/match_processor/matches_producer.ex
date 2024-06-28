defmodule LolAnalytics.MatchProcessor.MatchesProducer do
  use GenStage

  @impl GenStage
  def init(opts) do
    {:producer, opts}
  end

  def start_link(opts) do
    GenStage.start_link(__MODULE__, :ok)
  end

  @impl GenStage
  def handle_demand(demand, state) do
    matches = query_unprocessed_matches(demand)

    {:noreply, matches, state}
  end

  defp query_unprocessed_matches(demand) when demand <= 0, do: []

  defp query_unprocessed_matches(demand) do
    LolAnalytics.Dimensions.Match.MatchRepo.list_unprocessed_matches(demand)
    |> Enum.map(&broadway_transform/1)
  end

  defp broadway_transform(match) do
    %Broadway.Message{
      data: match,
      acknowledger: Broadway.NoopAcknowledger.init()
    }
  end
end
