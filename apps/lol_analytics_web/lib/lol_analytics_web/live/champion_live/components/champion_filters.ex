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
      |> assign(:form, build_roles_form())

    {:ok, socket}
  end

  defp build_roles() do
    @roles_definition
    |> Enum.reduce(%{}, fn role, acc ->
      Map.merge(acc, %{"#{role.value}" => false})
    end)
    |> Map.merge(%{"all" => true})
  end

  defp build_roles_form() do
    @roles_definition
    |> Enum.reduce(%{}, fn role, acc ->
      Map.merge(acc, %{"#{role.value}" => false})
    end)
    |> Map.merge(%{"all" => true})
    |> to_form
  end

  def handle_event("filter", unsigned_params, socket) do
    # updated_form =
    #   unsigned_params
    #   |> Enum.map(fn {key, val} -> {key, key == unsigned_params["_target"]} end)

    IO.inspect(unsigned_params)
    # # assign()
    # {:noreply, socket |> assign(:form, to_form(updated_form))}
  end

  attr :selectedrole, :string, required: true
  attr :roles, :list, default: []

  def render(assigns) do
    IO.puts(">>>>1")
    # IO.inspect(assigns)
    IO.inspect(assigns.selectedrole)
    IO.inspect(">>>>>2")

    selected_class =
      "px-8 py-2 flex flex-row gap-2 align-middle rounded-md border-gray-200 border border-sky-500"

    ~H"""
    <div>
      <div class="flex flex-row justify-between p-10">
        <%= for role <- @roles do %>
          <%!-- <%= IO.inspect(role) %> --%>
          <%= if (assigns.selectedrole == role.value) do %>
            <div phx-click="filter" phx-value-role={role.title} class={selected_class}>
              <%!-- <.input enabled={false} type="checkbox" field={@form[role.value]} /> --%>
              <p><%= role.title %></p>
            </div>
          <% else %>
            <div
              phx-click="filter"
              phx-value-role={role.value}
              class="px-8 py-2 flex flex-row gap-2 align-middle"
            >
              <%!-- <.input enabled={false} type="checkbox" field={@form[role.value]} /> --%>
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
