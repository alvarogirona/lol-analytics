defmodule LoLAnalyticsWeb.ChampionLive.Index do
  use LoLAnalyticsWeb, :live_view

  import LolAnalyticsWeb.ChampionComponents.ChampionCard
  import LolAnalyticsWeb.Loader
  import Phoenix.VerifiedRoutes

  alias LolAnalyticsWeb.ChampionLive.Mapper
  alias LolAnalyticsWeb.ChampionLive.Components.ChampionFilters

  @behaviour LolAnalyticsWeb.ChampionFilters.EventHandler

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:champions, %{status: :loading})
      |> load_champs("all")
      |> assign(:selected_role, "all")

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      case params["role"] do
        role -> {:noreply, assign(socket, selected_role: role)}
        _ -> {:noreply, socket}
      end
  end

  @impl true
  def handle_event("filter", %{"role" => selected_role} = params, socket) do
    {:reply, %{},
     socket
     |> push_navigate(to: ~p"/champions?#{params}")
     |> assign(:champions, %{status: :loading})
     |> load_champs(selected_role)
     |> assign(:selected_role, selected_role)}
  end

  defp load_champs(socket, selected_role) do
    socket
    |> start_async(
      :get_champs,
      fn ->
        LolAnalytics.Facts.ChampionPlayedGame.Repo.get_win_rates()
        |> filter_champs(selected_role)
      end
    )
  end

  def handle_async(:get_champs, {:ok, fetched_events} = params, socket) do
    {:noreply, assign(socket, :champions, %{status: :data, data: fetched_events})}
  end

  def render_champions(assigns) do
    case assigns.champions do
      %{status: :loading} ->
        ~H"""
        <.loader />
        """

      %{status: :data, data: champions} ->
        ~H"""
        <div id="champions" class="grid grid-cols-4 gap-4">
          <%= for champion <- champions do %>
            <.champion_card props={champion} />
          <% end %>
        </div>
        """
    end
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
