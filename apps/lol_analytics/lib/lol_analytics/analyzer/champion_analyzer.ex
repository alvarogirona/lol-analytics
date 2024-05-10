defmodule LolAnalytics.Analyzer.ChampionAnalyzer do
  alias Hex.HTTP
  @behaviour LolAnalytics.Analyzer.BaseAnalyzer

  @doc """
  iex> LolAnalytics.Analyzer.ChampionAnalyzer.analyze(:url, "https://na1.api.riotgames.com/lol/match/v4/match/234567890123456789")
  :ok
  """
  @impl true
  @spec analyze(atom(), String.t()) :: :ok
  def analyze(:url, path) do
    data = HTTPoison.get!(path)
    analyze(:data, data.body)
    :ok
  end

  @doc """
  iex> LolAnalytics.Analyzer.ChampionAnalyzer.analyze(:url, "http://localhost:9000/ranked/14.9.580.2108/EUW1_6923309745.json")
  """
  @impl true
  @spec analyze(atom(), any()) :: list(LoLAPI.Model.Participant.t())
  def analyze(:data, data) do
    decoded = Poison.decode!(data)

    %{"info" => %{"participants" => participants}} = decoded

    participants
    |> Enum.each(fn %{"win" => win, "championId" => champion_id} ->
      IO.inspect(%{win: win, champion_id: champion_id})
    end)
  end
end
