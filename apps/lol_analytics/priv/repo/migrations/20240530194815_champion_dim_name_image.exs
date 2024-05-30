defmodule LoLAnalytics.Repo.Migrations.ChampionDimName do
  use Ecto.Migration

  def change do
    alter table("dim_champion") do
      add :name, :string
      add :image, :string
    end
  end
end
