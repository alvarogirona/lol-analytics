defmodule LolAnalytics.Facts.ChampionPickedSummonerSpell.Repo do
  import Ecto.Query

  alias LolAnalytics.Dimensions.Patch.PatchRepo
  alias LolAnalytics.Dimensions.SummonerSpell.SummonerSpellSchema
  alias LolAnalytics.Dimensions.SummonerSpell.SummonerSpellRepo
  alias LolAnalytics.Dimensions.Champion.ChampionSchema

  alias LolAnalytics.Facts.ChampionPickedSummonerSpell.Schema

  alias LolAnalytics.Dimensions.Player.PlayerRepo
  alias LolAnalytics.Dimensions.Champion.ChampionRepo
  alias LolAnalytics.Dimensions.Match.MatchRepo

  alias LoLAnalytics.Repo

  @spec insert(%{
          :champion_id => String.t(),
          :match_id => String.t(),
          :patch_number => String.t(),
          :puuid => any(),
          :summoner_spell_id => String.t()
        }) :: any()
  def insert(attrs) do
    _champion = ChampionRepo.get_or_create(attrs.champion_id)
    _player = PlayerRepo.get_or_create(attrs.puuid)
    _spell = SummonerSpellRepo.get_or_create(attrs.summoner_spell_id)
    _patch = PatchRepo.get_or_create(attrs.patch_number)

    match =
      MatchRepo.get_or_create(%{
        match_id: attrs.match_id,
        patch_number: attrs.patch_number,
        queue_id: attrs.queue_id
      })

    prev =
      from(f in Schema,
        where:
          f.match_id == ^attrs.match_id and
            f.champion_id == ^attrs.champion_id and
            f.summoner_spell_id ==
              ^attrs.summoner_spell_id
      )
      |> Repo.one()

    Schema.changeset(prev || %Schema{}, attrs)
    |> Repo.insert_or_update()

    MatchRepo.update(match, %{fact_champion_picked_summoner_spell: :processed})
  end

  @spec get_champion_picked_summoners(String.t(), String.t(), String.t()) :: list()
  def get_champion_picked_summoners(champion_id, team_position, patch_number) do
    query =
      from f in Schema,
        where:
          f.champion_id == ^champion_id and
            f.team_position == ^team_position and
            f.patch_number == ^patch_number,
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
          spell_id: f.summoner_spell_id,
          metadata: s.metadata,
          champion_id: c.champion_id,
          team_position: f.team_position,
          total_games: count("*")
        },
        group_by: [
          f.champion_id,
          f.summoner_spell_id,
          s.metadata,
          c.champion_id,
          f.team_position
        ]

    Repo.all(query)
  end
end
