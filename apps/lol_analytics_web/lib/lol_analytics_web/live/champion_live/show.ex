defmodule LoLAnalyticsWeb.ChampionLive.Show do
  use LoLAnalyticsWeb, :live_view

  import LolAnalyticsWeb.ChampionComponents.SummonerSpells
  import LolAnalyticsWeb.ChampionComponents.ChampionAvatar

  alias LolAnalyticsWeb.ChampionComponents.SummonerSpells.ShowMapper

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:champion, load_champion_info(id) |> ShowMapper.map_champion())
     |> assign(:summoner_spells, %{
       summoner_spells: load_summoner_spells(id) |> ShowMapper.map_spells()
     })}
  end

  defp load_summoner_spells(champion_id) do
    LolAnalytics.Facts.ChampionPickedSummonerSpell.Repo.get_champion_picked_summoners(champion_id)
  end

  defp load_items(champion_id) do
    LolAnalytics.Facts.ChampionPickedItem.Repo.get_champion_picked_items(champion_id)
  end

  defp load_champion_info(champion_id) do
    champion = LolAnalytics.Dimensions.Champion.ChampionRepo.get_or_create(champion_id)

    IO.inspect(champion)

    champion
  end

  defp page_title(:show), do: "Show Champion"
  defp page_title(:edit), do: "Edit Champion"
end
