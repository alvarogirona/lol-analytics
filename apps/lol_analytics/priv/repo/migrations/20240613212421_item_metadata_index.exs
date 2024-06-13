defmodule LoLAnalytics.Repo.Migrations.ItemMetadataIndex do
  use Ecto.Migration

  def up do
    execute("CREATE INDEX dim_item_metadata ON dim_item USING GIN(metadata)")
  end

  def down do
    execute("DROP INDEX dim_item_metadata")
  end
end
