defmodule LoLAnalytics.Repo.Migrations.Player do
  use Ecto.Migration

  def change do
    create table("player") do
      add :puuid, :string, primary_key: true
      add :region, :string
      add :last_processed_at, :utc_datetime
      add :status, :string, default: "queued"
      timestamps()
    end

    create index(:player, [:puuid])
  end
end
