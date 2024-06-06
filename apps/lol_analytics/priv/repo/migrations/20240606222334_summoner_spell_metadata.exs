defmodule LoLAnalytics.Repo.Migrations.SummonerSpellMetadata do
  use Ecto.Migration

  def change do
    alter table("dim_summoner_spell") do
      add :metadata, :map
    end
  end
end
