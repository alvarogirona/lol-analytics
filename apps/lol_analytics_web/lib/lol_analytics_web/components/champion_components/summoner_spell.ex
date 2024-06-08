defmodule LolAnalyticsWeb.ChampionComponents.SummonerSpells.Props.SummonerSpell do
  defstruct [:id, :name, :win_rate, :wins, :total_games, :image]

  @type t :: %{
          id: integer(),
          win_rate: float(),
          wins: integer(),
          total_games: integer(),
          image: String.t(),
          name: String.t()
        }
end

defmodule LolAnalyticsWeb.ChampionComponents.SummonerSpells.Props do
  alias LolAnalyticsWeb.ChampionComponents.SummonerSpells.Props.SummonerSpell

  defstruct spell: %SummonerSpell{}

  @type t :: %{spell: SummonerSpell.t()}
end

defmodule LolAnalyticsWeb.ChampionComponents.SummonerSpell do
  alias LolAnalyticsWeb.ChampionComponents.SummonerSpells.Props
  use Phoenix.Component

  attr :spells, Props, default: %Props{}

  def summoner_spells(assigns) do
    ~H"""
    <div class="flex flex-wrap flex-wrap gap-4">
      <%= for spell <- assigns.spells.summoner_spells do %>
        <div clas="flex flex-col gap-1">
          <img src={spell.spell.image} />
          <p><%= spell.spell.name %></p>
          <p><%= spell.spell.win_rate %>%</p>
          <p><%= spell.spell.wins %>/<%= spell.spell.total_games %></p>
        </div>
      <% end %>
    </div>
    """
  end
end
