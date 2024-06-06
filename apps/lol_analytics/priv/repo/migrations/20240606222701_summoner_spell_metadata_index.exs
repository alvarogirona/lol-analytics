defmodule LoLAnalytics.Repo.Migrations.SummonerSpellMetadataIndex do
  use Ecto.Migration

  def up do
    execute("CREATE INDEX dim_summoner_spell_metadata ON dim_summoner_spell USING GIN(metadata)")
  end

  def down do
    execute("DROP INDEX dim_summoner_spell_metadata")
  end
end
