defmodule LoLAnalyticsWeb.ChampionLive.Show do
  use LoLAnalyticsWeb, :live_view

  import LolAnalyticsWeb.ChampionComponents.SummonerSpells
  import LolAnalyticsWeb.ChampionComponents.ChampionAvatar
  import LolAnalyticsWeb.ChampionComponents.Items

  alias LolAnalyticsWeb.ChampionComponents.SummonerSpells.ShowMapper

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "team-position" => team_position, "patch" => patch}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:champion, load_champion_info(id))
     |> assign(:summoner_spells, %{
       summoner_spells: load_summoner_spells(id, team_position)
     })
     |> load_items(id, team_position, patch)}
  end

  defp load_summoner_spells(champion_id, team_position) do
    LolAnalytics.Facts.ChampionPickedSummonerSpell.Repo.get_champion_picked_summoners(
      champion_id,
      team_position
    )
    |> ShowMapper.map_spells()
  end

  defp load_items(socket, champion_id, team_position, patch) do
    items =
      LolAnalytics.Facts.ChampionPickedItem.Repo.get_champion_picked_items(
        champion_id,
        team_position,
        patch
      )

    all_items_mapped = items |> ShowMapper.map_items() |> Enum.take(30)
    boots = items |> ShowMapper.extract_boots()

    socket
    |> assign(:items, all_items_mapped)
    |> assign(:boots, boots)
  end

  defp load_champion_info(champion_id) do
    LolAnalytics.Dimensions.Champion.ChampionRepo.get_or_create(champion_id)
    |> ShowMapper.map_champion()
  end

  defp page_title(:show), do: "Show Champion"
  defp page_title(:edit), do: "Edit Champion"
end
