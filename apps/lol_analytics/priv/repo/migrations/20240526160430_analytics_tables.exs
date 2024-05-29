defmodule LoLAnalytics.Repo.Migrations.AnalyticsTables do
  use Ecto.Migration

  def change do
    create table("dom_champion") do
      add :champion_id, :integer, primary_key: true
      timestamps()
    end

    create table("dom_match") do
      add :match_id, :integer, primary_key: true
      timestamps()
    end

    create index("dom_match", [:match_id], unique: true)

    create table("dom_patch") do
      add :patch_number, :string, primary_key: true
      timestamps()
    end

    create index("dom_patch", [:patch_number], unique: true)

    create table("dom_item") do
      add :item_id, :integer, primary_key: true
      timestamps()
    end

    create index("dom_item", [:item_id], unique: true)

    create table("dom_summoner_spell") do
      add :spell_id, :integer, primary_key: true
      timestamps()
    end

    create index("dom_summoner_spell", [:spell_id], unique: true)

    create table("fact_champion_played_game") do
      add :champion_id, references("dom_champion", with: [champion_id: :champion_id]),
        primary_key: true

      add :match_id, references("dom_match", with: [match_id: :match_id])
      add :is_win, :boolean
      add :game_length_seconds, :integer
      add :queue_id, :integer
      timestamps()
    end

    create index("fact_champion_played_game", [:id, :champion_id, :queue_id])
  end
end
