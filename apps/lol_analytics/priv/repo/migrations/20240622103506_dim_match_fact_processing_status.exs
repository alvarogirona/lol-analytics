defmodule LoLAnalytics.Repo.Migrations.DimMatchFactProcessingStatus do
  use Ecto.Migration

  def change do
    alter table("dim_match") do
      add :fact_champion_played_game_status, :integer, default: 0
      add :fact_champion_picked_item_status, :integer, default: 0
      add :fact_champion_picked_summoner_spell_status, :integer, default: 0
    end

    create index("dim_match", [:fact_champion_played_game_status])
    create index("dim_match", [:fact_champion_picked_item_status])
    create index("dim_match", [:fact_champion_picked_summoner_spell_status])
  end
end
