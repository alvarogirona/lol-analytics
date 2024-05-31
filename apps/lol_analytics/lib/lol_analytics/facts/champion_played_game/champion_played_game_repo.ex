defmodule LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameRepo do
  import Ecto.Query

  alias LolAnalytics.Dimensions.Champion.ChampionSchema
  alias LolAnalytics.Dimensions.Player.PlayerRepo
  alias LolAnalytics.Dimensions.Champion.ChampionRepo
  alias LolAnalytics.Dimensions.Match.MatchRepo
  alias LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameSchema
  alias LoLAnalytics.Repo

  def insert(attrs) do
    _match = MatchRepo.get_or_create(attrs.match_id)
    _champion = ChampionRepo.get_or_create(attrs.champion_id)
    _player = PlayerRepo.get_or_create(attrs.puuid)
    changeset = ChampionPlayedGameSchema.changeset(%ChampionPlayedGameSchema{}, attrs)
    Repo.insert(changeset)
  end

  def list_played_matches() do
    Repo.all(ChampionPlayedGameSchema)
  end

  def get_win_rates do
    query =
      from m in ChampionPlayedGameSchema,
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
        group_by: [m.champion_id, c.image, c.name, m.team_position]

    Repo.all(query)
  end

  def get_win_rates_by_roles() do
  end
end
