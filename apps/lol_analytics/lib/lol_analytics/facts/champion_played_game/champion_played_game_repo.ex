defmodule LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameRepo do
  import Ecto.Query

  alias LolAnalytics.Dimensions.Champion.ChampionSchema
  alias LolAnalytics.Dimensions.Player.PlayerRepo
  alias LolAnalytics.Dimensions.Champion.ChampionRepo
  alias LolAnalytics.Dimensions.Match.MatchRepo
  alias LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameSchema
  alias LolAnalytics.Facts.ChampionPlayedGame
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

  def get_win_rates2 do
    query2 =
      from m in ChampionPlayedGameSchema,
        join: c in ChampionSchema,
        on: c.champion_id == m.champion_id,
        select: %{
          wins: count(m.is_win),
          win_rate:
            fragment(
              "
              ((cast(count(CASE WHEN ? THEN 1 END) as float) / cast(count(*) as float)) * 100.0
              )",
              m.is_win
            ),
          id: m.champion_id,
          name: c.name,
          image: c.image
        },
        group_by: [m.champion_id, c.image, c.name]

    Repo.all(query2)
  end

  def get_win_rates() do
    query = """
    SELECT
      (cast(count(CASE WHEN is_win THEN 1 END) as float) / cast(count(*) as float)) * 100.0 as win_rate,
      count(CASE WHEN is_win THEN 1 END) as games_won,
      count(*) as total_games,
      champion_id
      FROM fact_champion_played_game

      GROUP BY champion_id
      ORDER BY win_rate desc;
    """

    case Ecto.Adapters.SQL.query(Repo, query, []) do
      {:ok, %Postgrex.Result{rows: rows}} ->
        rows
        |> Enum.map(fn [win_rate, wins, games, champion_id] ->
          %{
            win_rate: win_rate,
            wins: wins,
            games: games,
            champion_id: champion_id
          }
        end)

      {:error, _exception} ->
        :error
    end
  end

  def get_win_rates_by_roles() do
  end
end
