defmodule LolAnalytics.Facts.ChampionPickedSummonerSpell.Repo do
  import Ecto.Query

  alias LolAnalytics.Dimensions.SummonerSpell.SummonerSpellSchema
  alias LolAnalytics.Dimensions.SummonerSpell.SummonerSpellRepo
  alias LolAnalytics.Dimensions.Champion.ChampionSchema

  alias LolAnalytics.Facts.ChampionPickedSummonerSpell.Schema

  alias LolAnalytics.Dimensions.Player.PlayerRepo
  alias LolAnalytics.Dimensions.Champion.ChampionRepo
  alias LolAnalytics.Dimensions.Match.MatchRepo

  alias LoLAnalytics.Repo

  @type insert_attrs :: %{
          match_id: String.t(),
          champion_id: String.t(),
          puuid: String.t(),
          summoner_spell_id: :integer
        }

  @spec insert(insert_attrs()) :: any()
  def insert(attrs) do
    _match = MatchRepo.get_or_create(attrs.match_id)
    _champion = ChampionRepo.get_or_create(attrs.champion_id)
    _player = PlayerRepo.get_or_create(attrs.puuid)
    _spell = SummonerSpellRepo.get_or_create(attrs.summoner_spell_id)

    prev =
      from(f in Schema,
        where:
          f.match_id == ^attrs.match_id and
            f.champion_id == ^attrs.champion_id and
            f.summoner_spell_id ==
              ^attrs.summoner_spell_id
      )
      |> Repo.one()

    changeset = Schema.changeset(prev || %Schema{}, attrs)

    IO.inspect(attrs)

    Repo.insert_or_update(changeset)
    |> IO.inspect()
  end

  def get_champion_picked_summoners(championId, team_position \\ "MIDDLE") do
    query =
      from f in Schema,
        where: f.champion_id == ^championId and f.team_position == ^team_position,
        join: c in ChampionSchema,
        on: c.champion_id == f.champion_id,
        join: s in SummonerSpellSchema,
        on: s.spell_id == f.summoner_spell_id,
        select: %{
          wins: fragment("count(CASE WHEN ? THEN 1 END)", f.is_win),
          win_rate:
            fragment(
              "
              ((cast(count(CASE WHEN ? THEN 1 END) as float) / cast(count(*) as float)) * 100.0
              )",
              f.is_win
            ),
          id: f.champion_id,
          spell_id: f.summoner_spell_id,
          metadata: s.metadata,
          champion_name: c.name,
          champion_id: c.champion_id,
          team_position: f.team_position,
          total_games: count("*")
        },
        group_by: [
          f.champion_id,
          f.summoner_spell_id,
          s.metadata,
          c.image,
          c.name,
          c.champion_id,
          f.team_position
        ]

    Repo.all(query)
  end

  def list_facts() do
    Repo.all(Schema)
  end
end
