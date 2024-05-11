defmodule LoLAnalytics.Repo.Migrations.ChampionWinRate do
  use Ecto.Migration

  def change do
    create table("champion_win_rate") do
      add :champion_id, :integer
      add :patch, :string
      add :position, :string
      add :total_games, :integer
      add :total_wins, :integer
      timestamps()
    end

    alter table("match") do
      add :win_rate_processed, :boolean, default: false
    end

    index("champion_win_rate", [:champion_id], unique: false)
    index("champion_win_rate", [:champion_id, :patch], unique: true)
  end
end
