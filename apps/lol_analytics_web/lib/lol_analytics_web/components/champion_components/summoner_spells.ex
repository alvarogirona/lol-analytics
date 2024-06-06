defmodule LolAnalyticsWeb.ChampionComponents.SummonerSpells.SummonerSpell do
  defstruct [:id, :win_rate, :total_games]

  @type t :: %{
          id: integer(),
          win_rate: float(),
          total_games: integer()
        }
end

defmodule LolAnalyticsWeb.ChampionComponents.SummonerSpells.Props do
  alias LolAnalyticsWeb.ChampionComponents.SummonerSpells.SummonerSpell

  defstruct spell1: %SummonerSpell{},
            spell2: %SummonerSpell{}

  @type t :: %{
          spell1: SummonerSpell.t(),
          spell2: SummonerSpell.t()
        }
end

defmodule LolAnalyticsWeb.ChampionComponents.SummonerSpells do
  alias LolAnalyticsWeb.ChampionComponents.SummonerSpells.Props
  use Phoenix.Component

  attr :spells, Props, default: %Props{}

  def summoner_spells(assigns) do
    ~H"""
    <div>
      Spells
    </div>
    """
  end
end
