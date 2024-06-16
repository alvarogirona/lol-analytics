defmodule LoLAnalyticsWeb.ChampionLive.Show do
  use LoLAnalyticsWeb, :live_view

  import LolAnalyticsWeb.ChampionComponents.SummonerSpells
  import LolAnalyticsWeb.ChampionComponents.ChampionAvatar
  import LolAnalyticsWeb.ChampionComponents.Items
  import LolAnalyticsWeb.Loader

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
     |> load_win_rates(id, team_position)
     |> load_summoner_spells(id, team_position)
     |> load_items(id, team_position, patch)}
  end

  def load_win_rates(socket, champion_id, team_position) do
    socket
    |> start_async(:get_win_rates, fn ->
      LolAnalytics.Facts.ChampionPlayedGame.Repo.champion_win_rates_by_patch(
        champion_id,
        team_position
      )
      |> Enum.sort(fn p1, p2 ->
        [_, minor_1] = String.split(p1.patch_number, ".") |> Enum.map(&String.to_integer/1)
        [_, minor_2] = String.split(p2.patch_number, ".") |> Enum.map(&String.to_integer/1)

        p1 < p2 && minor_1 < minor_2
      end)
    end)
  end

  defp load_summoner_spells(socket, champion_id, team_position) do
    socket
    |> assign(:summoner_spells, %{status: :loading})
    |> start_async(:get_summoners, fn ->
      LolAnalytics.Facts.ChampionPickedSummonerSpell.Repo.get_champion_picked_summoners(
        champion_id,
        team_position
      )
      |> ShowMapper.map_spells()
    end)
  end

  defp load_items(socket, champion_id, team_position, patch) do
    socket
    |> assign(:items, %{status: :loading})
    |> assign(:boots, %{status: :loading})
    |> start_async(
      :get_items,
      fn ->
        items =
          LolAnalytics.Facts.ChampionPickedItem.Repo.get_champion_picked_items(
            champion_id,
            team_position,
            patch
          )

        popular_items = items |> ShowMapper.map_items() |> Enum.take(30)

        boots = items |> ShowMapper.extract_boots()

        %{boots: boots, popular: popular_items}
      end
    )
  end

  @impl true
  @spec handle_async(:get_items | :get_summoners | :get_win_rates, {:ok, any()}, map()) ::
          {:noreply, map()}
  def handle_async(:get_win_rates, {:ok, result}, socket) do
    {:noreply, push_event(socket, "win-rate", %{winRates: result})}
  end

  def handle_async(:get_items, {:ok, %{popular: popular, boots: boots}} = result, socket) do
    socket =
      socket
      |> assign(:items, %{
        status: :data,
        data: %{
          popular: popular,
          boots: boots
        }
      })

    {:noreply, socket}
  end

  def handle_async(:get_summoners, {:ok, summoner_spells}, socket) do
    socket =
      assign(socket, :summoner_spells, %{
        status: :data,
        data: summoner_spells
      })

    {:noreply, socket}
  end

  defp load_champion_info(champion_id) do
    LolAnalytics.Dimensions.Champion.ChampionRepo.get_or_create(champion_id)
    |> ShowMapper.map_champion()
  end

  defp page_title(:show), do: "Show Champion"
  defp page_title(:edit), do: "Edit Champion"

  def render_summoner_spells(assigns) do
  end

  def render_items(assigns) do
    case assigns.items do
      %{status: :loading} ->
        ~H"""
        <.loader />
        """

      %{status: :data, data: data} ->
        ~H"""
        <%= if Enum.count(data.boots) > 0 do %>
          <h2 class="text-2xl">Items</h2>

          <h2 class="text-xl">Boots</h2>

          <div class="my-2" />

          <.items items={data.boots} />

          <div class="my-4" />
        <% end %>

        <h2 class="text-xl">Popular items</h2>

        <div class="my-2" />

        <.items items={data.popular} />
        """
    end
  end

  def render_summoners(assigns) do
    case assigns.summoner_pells do
      %{status: :loading} ->
        ~H"""
        <.loader />
        """

      %{status: :data, data: data} ->
        ~H"""
        <h2 class="text-2xl">Summoner spells</h2>

        <div class="my-2" />

        <.summoner_spells spells={data} />
        """
    end
  end
end
