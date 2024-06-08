defmodule LoLAnalyticsWeb.ChampionLive.Index do
  use LoLAnalyticsWeb, :live_view

  import LolAnalyticsWeb.ChampionComponents.ChampionCard

  alias LolAnalyticsWeb.ChampionLive.Mapper
  alias LolAnalyticsWeb.ChampionLive.Components.ChampionFilters

  @behaviour LolAnalyticsWeb.ChampionFilters.EventHandler

  @roles [
    %{title: "All", value: "all"},
    %{title: "Top", value: "TOP"},
    %{title: "Jungle", value: "JUNGLE"},
    %{title: "Mid", value: "MIDDLE"},
    %{title: "Bot", value: "BOTTOM"},
    %{title: "Support", value: "UTILITY"}
  ]

  @impl true
  def mount(_params, _session, socket) do
    champs = LolAnalytics.Facts.ChampionPlayedGame.Repo.get_win_rates()

    mapped =
      champs
      |> Mapper.map_champs()
      |> Enum.sort(&(&1.win_rate >= &2.win_rate))

    socket =
      socket
      |> stream(:champions, mapped)
      |> assign(:selected_role, "all")

    {:ok, socket}
  end

  @impl true
  def handle_event("filter", %{"role" => selected_role} = params, socket) do
    champs =
      LolAnalytics.Facts.ChampionPlayedGame.Repo.get_win_rates()
      |> filter_champs(selected_role)

    {:noreply,
     socket
     |> stream(:champions, champs)
     |> assign(:selected_role, selected_role)}
  end

  def handle_event("filter_champs", params, socket) do
  end

  defp filter_champs(champs, selected_role) do
    champs =
      LolAnalytics.Facts.ChampionPlayedGame.Repo.get_win_rates()
      |> Enum.filter((&filter_role/1).(selected_role))
      |> Mapper.map_champs()
      |> Enum.sort(&(&1.win_rate >= &2.win_rate))
  end

  defp filter_role(role) do
    fn champ ->
      champ.team_position == role || role == "all"
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Champions")
  end
end
