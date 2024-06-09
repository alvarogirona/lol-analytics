defmodule LolAnalyticsWeb.ChampionLive.Components.ChampionFilters do
  use LoLAnalyticsWeb, :live_component

  @roles_definition [
    %{title: "All", value: "all"},
    %{title: "Top", value: "TOP"},
    %{title: "Jungle", value: "JUNGLE"},
    %{title: "Mid", value: "MIDDLE"},
    %{title: "Bot", value: "BOTTOM"},
    %{title: "Support", value: "UTILITY"}
  ]

  def on_role_selected(role) do
    send_update(LolAnalyticsWeb.ChampionLive, role)
  end

  def mount(socket) do
    socket =
      assign(socket, :roles, @roles_definition)

    {:ok, socket}
  end

  attr :selectedrole, :string, required: true
  attr :roles, :list, default: []

  def render(assigns) do
    selected_class =
      "px-8 py-2 flex flex-row gap-2 align-middle rounded-full border-gray-200 border border-orange-600 cursor-pointer"

    ~H"""
    <div>
      <div class="flex flex-row overflow-x-scroll sm:overflow-x-auto justify-between">
        <%= for role <- @roles do %>
          <%= if (assigns.selectedrole == role.value) do %>
            <div phx-click="filter" phx-value-role={role.title} class={selected_class}>
              <p><%= role.title %></p>
            </div>
          <% else %>
            <div
              phx-click="filter"
              phx-value-role={role.value}
              class="px-8 py-2 flex flex-row gap-2 align-middle cursor-pointer"
            >
              <p><%= role.title %></p>
            </div>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end
end

defmodule LolAnalyticsWeb.ChampionLive.Components.ChampionFilters.EventHandler do
  @callback role_selected() :: none()
end
