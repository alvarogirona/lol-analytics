defmodule LolAnalytics.Facts.ChampionPlayedGame.Repo do
  import Ecto.Query

  alias LolAnalytics.Dimensions.Patch.PatchRepo
  alias LolAnalytics.Dimensions.Champion.ChampionSchema
  alias LolAnalytics.Dimensions.Player.PlayerRepo
  alias LolAnalytics.Dimensions.Champion.ChampionRepo
  alias LolAnalytics.Dimensions.Match.MatchRepo
  alias LolAnalytics.Facts.ChampionPlayedGame.Schema
  alias LoLAnalytics.Repo

  def insert(attrs) do
    _match = MatchRepo.get_or_create(attrs.match_id)
    _champion = ChampionRepo.get_or_create(attrs.champion_id)
    _player = PlayerRepo.get_or_create(attrs.puuid)
    _patch = PatchRepo.get_or_create(attrs.patch_number)

    prev =
      from(f in Schema,
        where:
          f.match_id == ^attrs.match_id and
            f.champion_id == ^attrs.champion_id and f.queue_id == ^attrs.queue_id
      )
      |> Repo.one()

    changeset = Schema.changeset(prev || %Schema{}, attrs)

    Repo.update(changeset)
  end

  def list_played_matches() do
    Repo.all(Schema)
  end

  def get_win_rates do
    query =
      from m in Schema,
        join: c in ChampionSchema,
        on: c.champion_id == m.champion_id,
        select: %{
          wins: fragment("count(CASE WHEN ? THEN 1 END)", m.is_win),
          win_rate:
            fragment(
              "
              ((cast(count(CASE WHEN ? THEN 1 END) as float) / cast(count(*) as float)) * 100.0
              )",
              m.is_win
            ),
          id: m.champion_id,
          name: c.name,
          image: c.image,
          team_position: m.team_position,
          total_games: count("*")
        },
        group_by: [m.champion_id, c.image, c.name, m.team_position],
        having: count("*") > 100

    Repo.all(query)
  end

  def get_win_rates_by_patch(champion_id) do
    query =
      from m in Schema,
        join: c in ChampionSchema,
        on: c.champion_id == m.champion_id,
        select: %{
          wins: fragment("count(CASE WHEN ? THEN 1 END)", m.is_win),
          win_rate:
            fragment(
              "
              ((cast(count(CASE WHEN ? THEN 1 END) as float) / cast(count(*) as float)) * 100.0
              )",
              m.is_win
            ),
          id: m.champion_id,
          patch_number: m.patch_number,
          name: c.name,
          image: c.image,
          team_position: m.team_position,
          total_games: count("*")
        },
        where: c.champion_id == ^champion_id,
        group_by: [m.champion_id, c.image, c.name, m.team_position, m.patch_number],
        having: count("*") > 100

    Repo.all(query)
  end

  def get_win_rates_by_roles() do
  end
end
