defmodule LolAnalyticsWeb.ChampionComponents.SummonerSpells do
  alias LolAnalyticsWeb.ChampionComponents.SummonerSpells.Props
  use Phoenix.Component

  def summoner_spells(assigns) do
    ~H"""
    <div class="flex flex-wrap flex-wrap gap-4">
      <%= for spell <- assigns.spells do %>
        <div class="has-tooltip">
          <div clas="flex flex-col gap-1">
            <img class="rounded-xl" src={spell.image} />
            <p><%= spell.win_rate %>%</p>
            <p class="text-xs"><%= spell.wins %>/<%= spell.total_games %></p>
          </div>
          <div class="tooltip -my-8 px-4 py-2 rounded-xl">
            <p><%= spell.name %></p>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
