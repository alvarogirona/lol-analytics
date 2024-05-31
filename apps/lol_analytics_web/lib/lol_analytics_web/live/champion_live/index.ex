defmodule LoLAnalyticsWeb.ChampionLive.Index do
  alias LolAnalyticsWeb.ChampionLive.Mapper
  use LoLAnalyticsWeb, :live_view

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
    champs = LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameRepo.get_win_rates()

    mapped =
      champs
      |> Mapper.map_champs()
      |> Enum.sort(&(&1.win_rate >= &2.win_rate))

    roles =
      @roles
      |> Enum.reduce(%{}, fn role, acc ->
        Map.merge(acc, %{"#{role.value}" => false})
      end)
      |> Map.merge(%{"all" => true})

    form =
      Map.merge(
        %{"name" => ""},
        roles
      )

    socket =
      socket
      |> stream(
        :champions,
        mapped
      )
      |> assign(:form, to_form(form))
      |> assign(:roles, @roles)

    {:ok, socket}
  end

  @impl true
  def handle_event("filter", params, socket) do
    %{
      "name" => query_name,
      "all" => all,
      "TOP" => top,
      "JUNGLE" => jungle,
      "MIDDLE" => mid,
      "BOTTOM" => bot,
      "UTILITY" => utility
    } = params

    IO.inspect(params)

    filter =
      if all == "true" do
        nil
      else
        %{
          "TOP" => top == "true",
          "JUNGLE" => jungle == "true",
          "MIDDLE" => mid == "true",
          "BOTTOM" => bot == "true",
          "UTILITY" => utility == "true"
        }
        |> Enum.filter(fn {_k, v} -> v end)
        |> Enum.map(fn {k, _v} -> k end)
      end

    IO.puts(">>>>> 3")
    IO.inspect(filter)

    champs =
      LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameRepo.get_win_rates()
      |> Enum.filter(fn %{name: name} ->
        String.downcase(name) |> String.contains?(query_name)
      end)
      |> Enum.filter(fn champ ->
        if filter != nil do
          Enum.any?(filter, fn f -> f == champ.team_position end)
        end
      end)
      |> Mapper.map_champs()
      |> Enum.sort(&(&1.win_rate >= &2.win_rate))

    {:noreply,
     stream(
       socket,
       :champions,
       champs
     )}
  end

  def handle_event("filter", unsigned_params, socket) do
    {:noreply, socket}
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
end
