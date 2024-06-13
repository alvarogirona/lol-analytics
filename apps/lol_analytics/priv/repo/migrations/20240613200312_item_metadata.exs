defmodule LoLAnalytics.Repo.Migrations.ItemMetadata do
  use Ecto.Migration

  def change do
    alter table("dim_item") do
      add :metadata, :map
    end
  end
end
