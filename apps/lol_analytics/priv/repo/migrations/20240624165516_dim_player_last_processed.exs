defmodule LoLAnalytics.Repo.Migrations.DimPlayerLastProcessed do
  use Ecto.Migration

  def change do
    alter table "dim_player" do
      add :last_processed_at, :utc_datetime
    end
  end
end
