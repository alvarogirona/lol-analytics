defmodule LolAnalyticsWeb.ChampionComponents.SummonerSpells do
  alias LolAnalyticsWeb.ChampionComponents.SummonerSpells.Props
  use Phoenix.Component

  def summoner_spells(assigns) do
    ~H"""
    <div class="flex flex-wrap flex-wrap gap-4">
      <%= for spell <- assigns.spells.summoner_spells do %>
        <div clas="flex flex-col gap-1">
          <img src={spell.image} />
          <p><%= spell.name %></p>
          <p><%= spell.win_rate %>%</p>
          <p><%= spell.wins %>/<%= spell.total_games %></p>
        </div>
      <% end %>
    </div>
    """
  end
end
