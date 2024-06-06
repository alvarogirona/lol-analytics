defmodule LoLAnalyticsWeb.ChampionLive.Show do
  use LoLAnalyticsWeb, :live_view

  import LolAnalyticsWeb.ChampionComponents.SummonerSpells

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:champion, %{id: id})
     |> assign(:summoner_spells, %{summoner_spells: load_summoner_spells()})}
  end

  defp load_summoner_spells() do
    %LolAnalyticsWeb.ChampionComponents.SummonerSpells.Props{
      spell1: %LolAnalyticsWeb.ChampionComponents.SummonerSpells.SummonerSpell{
        id: 1,
        win_rate: 51.7,
        total_games: 400
      },
      spell2: %LolAnalyticsWeb.ChampionComponents.SummonerSpells.SummonerSpell{
        id: 2,
        win_rate: 51.7,
        total_games: 500
      }
    }
  end

  defp page_title(:show), do: "Show Champion"
  defp page_title(:edit), do: "Edit Champion"
end
