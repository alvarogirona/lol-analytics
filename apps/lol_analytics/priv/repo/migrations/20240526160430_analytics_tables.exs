defmodule LoLAnalytics.Repo.Migrations.AnalyticsTables do
  use Ecto.Migration

  def change do
    create table("dim_champion") do
      add :champion_id, :integer, primary_key: true, null: false
      timestamps()
    end

    create index("dim_champion", [:champion_id], unique: true)

    create table("dim_item") do
      add :item_id, :integer, primary_key: true, null: false
      timestamps()
    end

    create index("dim_item", [:item_id], unique: true)

    create table("dim_match") do
      add :match_id, :string, primary_key: true, null: false
      timestamps()
    end

    create index("dim_match", [:match_id], unique: true)

    create table("dim_patch") do
      add :patch_number, :string, primary_key: true, null: false
      timestamps()
    end

    create index("dim_patch", [:patch_number], unique: true)

    create table("dim_player") do
      add :puuid, :string, primary_key: true, null: false
      timestamps()
    end

    create index("dim_player", [:puuid], unique: true)

    create table("dim_summoner_spell") do
      add :spell_id, :integer, primary_key: true, null: false
      timestamps()
    end

    create index("dim_summoner_spell", [:spell_id], unique: true)

    create table("fact_champion_played_game") do
      add :champion_id, references("dim_champion", column: :champion_id, type: :integer)
      add :match_id, references("dim_match", column: :match_id, type: :string)
      add :is_win, :boolean
      add :game_length_seconds, :integer
      add :queue_id, :integer
      add :patch_number, references("dim_patch", column: :patch_number, type: :string)
      add :team_position, :string
      add :puuid, references("dim_player", column: :puuid, type: :string)
      timestamps()
    end

    create index("fact_champion_played_game", [:id, :champion_id, :queue_id])
    create index("fact_champion_played_game", [:puuid, :match_id], unique: true)
  end
end
