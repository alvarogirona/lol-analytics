defmodule LoLAnalyticsWeb.ChampionLive.Index do
  use LoLAnalyticsWeb, :live_view

  import LolAnalyticsWeb.ChampionComponents.ChampionCard
  import LolAnalyticsWeb.Loader
  import Phoenix.VerifiedRoutes

  alias LolAnalyticsWeb.ChampionLive.Mapper
  alias LolAnalyticsWeb.ChampionLive.Components.ChampionFilters
  alias LolAnalyticsWeb.PatchSelector

  @behaviour LolAnalyticsWeb.ChampionFilters.EventHandler

  @impl true
  def mount(params, _session, socket) do
    role = params["role"] || "all"

    socket =
      socket
      |> assign(:selected_role, role)
      |> assign(:champions, %{status: :loading})
      |> load_champs(role, "all")

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    case params["role"] do
      role -> {:noreply, assign(socket, selected_role: role)}
      _ -> {:noreply, socket}
    end
  end

  @impl true
  def handle_event("filter", %{"role" => selected_role} = params, socket) do
    {:reply, %{},
     socket
     |> push_patch(to: ~p"/champions?#{params}")
     |> assign(:champions, %{status: :loading})
     |> load_champs(selected_role, socket.assigns.selected_patch)
     |> assign(:selected_role, selected_role)}
  end

  def handle_info(%{patch: patch}, socket) do
    selected_role = socket.assigns.selected_role

    socket =
      assign(socket, :champions, %{status: :loading})
      |> assign(:selected_patch, patch)
      |> load_champs(selected_role, patch)

    {:noreply, socket}
  end

  defp load_champs(socket, selected_role, "all") do
    socket
    |> start_async(
      :get_champs,
      fn ->
        LolAnalytics.Facts.ChampionPlayedGame.Repo.get_win_rates(team_position: selected_role)
        |> Mapper.map_champs()
        |> Enum.sort(&(&1.win_rate >= &2.win_rate))
      end
    )
  end

  defp load_champs(socket, selected_role, patch) do
    socket
    |> start_async(
      :get_champs,
      fn ->
        LolAnalytics.Facts.ChampionPlayedGame.Repo.get_win_rates(
          team_position: selected_role,
          patch_number: patch
        )
        |> Mapper.map_champs()
        |> Enum.sort(&(&1.win_rate >= &2.win_rate))
      end
    )
  end

  def handle_async(:get_champs, {:ok, champs}, socket) do
    {:noreply, assign(socket, :champions, %{status: :data, data: champs})}
  end

  def render_champions(assigns) do
    case assigns.champions do
      %{status: :loading} ->
        ~H"""
        <.loader />
        """

      %{status: :data, data: champions} ->
        ~H"""
        <div id="champions" class="grid grid-cols-2 sm:grid-cols-4  gap-4">
          <%= for champion <- champions do %>
            <.champion_card props={champion} />
          <% end %>
        </div>
        """
    end
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
