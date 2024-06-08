defmodule LolAnalyticsWeb.ChampionComponents.SummonerSpells.ShowMapper do
  alias LolAnalyticsWeb.ChampionComponents.SummonerSpells.SummonerSpell

  @spec map_champion(%LolAnalytics.Dimensions.Champion.ChampionSchema{}) :: map()
  def map_champion(champion) do
    %{
      id: champion.champion_id,
      name: champion.name,
      image: champion.image
    }
  end

  def map_spells(items) do
    items
    |> Enum.map(&map_spell/1)
    |> Enum.sort(&(&1.spell.total_games > &2.spell.total_games))
  end

  def map_spell(spell) do
    image = spell.metadata["image"]["full"]

    %LolAnalyticsWeb.ChampionComponents.SummonerSpells.Props{
      spell: %LolAnalyticsWeb.ChampionComponents.SummonerSpells.Props.SummonerSpell{
        id: spell.id,
        win_rate: :erlang.float_to_binary(spell.win_rate, decimals: 2),
        total_games: spell.total_games,
        image: "https://ddragon.leagueoflegends.com/cdn/14.11.1/img/spell/#{image}",
        name: spell.metadata["name"],
        wins: spell.wins
      }
    }
  end
end
