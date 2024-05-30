defmodule LoLAnalyticsWeb.ChampionLive.Index do
  alias ElixirLS.LanguageServer.Providers.Completion.Reducers.Struct
  use LoLAnalyticsWeb, :live_view

  defstruct id: "", win_rate: 0, wins: 0, image: "", name: ""

  @roles ["all", "TOP", "JUNGLE", "MIDDLE", "BOTTOM", "UTILITY"]

  @impl true
  def mount(_params, _session, socket) do
    champs = LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameRepo.get_win_rates2()

    mapped =
      champs
      |> Enum.map(fn champ ->
        Kernel.struct!(%__MODULE__{}, champ)
      end)
      |> Enum.sort(&(&1.win_rate >= &2.win_rate))

    {:ok,
     stream(
       socket,
       :champions,
       mapped
     )
     |> assign(:form, to_form(%{"name" => ""}))}
  end

  def handle_event("filter", params, socket) do
    %{"name" => query_name} = params

    champs =
      LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameRepo.get_win_rates2()
      |> Enum.filter(fn %{name: name} ->
        String.downcase(name) |> String.contains?(query_name)
      end)
      |> Enum.map(fn champ ->
        Kernel.struct!(%__MODULE__{}, champ)
      end)
      |> Enum.sort(&(&1.win_rate >= &2.win_rate))

    IO.inspect(champs)

    {:noreply,
     stream(
       socket,
       :champions,
       champs
     )}
  end

  def handle_event("filter_by", %{"name" => name}, socket) do
    {:noreply, assign(socket, %{filter_by: name})}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Champions")

    # |> assign(:champion, nil)
  end

  @impl true
  def handle_info({LoLAnalyticsWeb.ChampionLive.FormComponent, {:saved, champion}}, socket) do
    {:noreply, stream_insert(socket, :champions, champion)}
  end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   champion = Accounts.get_champion!(id)
  #   {:ok, _} = Accounts.delete_champion(champion)

  #   {:noreply, stream_delete(socket, :champions, champion)}
  # end
end
