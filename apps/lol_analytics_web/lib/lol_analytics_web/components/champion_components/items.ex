defmodule LolAnalyticsWeb.ChampionComponents.Items do
  use Phoenix.Component

  def items(assigns) do
    image = ""

    ~H"""
    <div class="flex flex-wrap flex-wrap gap-4">
      <%= for item <- assigns.items do %>
        <div class="has-tooltip">
          <div clas="flex flex-col gap-1 p-4">
            <img src={item.image} />
            <%!-- <p><%= item.name %></p> --%>
            <p><%= item.win_rate %>%</p>
            <p class="text-xs"><%= item.wins %>/<%= item.total_games %></p>
          </div>
          <span class="tooltip -mt-8 py-2 px-4 rounded-xl"><%= item.name %></span>
        </div>
      <% end %>
    </div>
    """
  end
end
