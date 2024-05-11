defmodule LolAnalytics.ChampionWinRate.ChampionWinRateRepo do
  import Ecto.Query
  alias LolAnalytics.ChampionWinRate.ChampionWinRateSchema
  alias LoLAnalytics.Repo

  @spec add_champion_win_rate(
          champion_id :: String.t(),
          patch :: String.t(),
          position :: String.t(),
          win? :: boolean
        ) :: {:ok, ChampionWinRateSchema.t()} | {:error, Ecto.Changeset.t()}
  def add_champion_win_rate(champion_id, patch, position, win?) do
    Repo.transaction(fn ->
      champion_query =
        from cwr in LolAnalytics.ChampionWinRate.ChampionWinRateSchema,
          where: cwr.champion_id == ^champion_id and cwr.position == ^position,
          lock: "FOR UPDATE"

      champion_data = Repo.one(champion_query)

      case champion_data do
        nil ->
          ChampionWinRateSchema.changeset(%ChampionWinRateSchema{}, %{
            champion_id: champion_id,
            patch: patch,
            total_games: 1,
            position: position,
            total_wins: if(win?, do: 1, else: 0)
          })
          |> Repo.insert!()

        _ ->
          total_games = champion_data.total_games + 1
          total_wins = champion_data.total_wins + if win?, do: 1, else: 0

          ChampionWinRateSchema.changeset(champion_data, %{
            total_games: total_games,
            total_wins: total_wins
          })
          |> Repo.update!()
      end
    end)
  end

  def list_win_rates() do
    Repo.all(ChampionWinRateSchema)
  end

  def get_champion_win_rate(champion_id, patch) do
    champion_query =
      from cwr in LolAnalytics.ChampionWinRate.ChampionWinRateSchema,
        where: cwr.champion_id == ^champion_id

    Repo.one(champion_query)
  end
end
