defmodule LoLAnalytics.Repo.Migrations.ChampionPickedItem do
  use Ecto.Migration

  def change do
    create table("fact_champion_picked_item") do
      add :champion_id, references("dim_champion", column: :champion_id, type: :integer)
      add :item_id, references("dim_item", column: :item_id, type: :integer)
      add :slot_number, :integer
      add :match_id, references("dim_match", column: :match_id, type: :string)
      add :is_win, :boolean
      add :game_length_seconds, :integer
      add :queue_id, :integer
      add :patch_number, references("dim_patch", column: :patch_number, type: :string)
      add :team_position, :string
      add :puuid, references("dim_player", column: :puuid, type: :string)
    end

    create index("fact_champion_picked_item", [:champion_id])
    create index("fact_champion_picked_item", [:puuid, :match_id, :slot_number, :item_id], unique: true)
    create index("fact_champion_picked_item", [
             :item_id,
             :queue_id,
             :is_win,
             :patch_number,
             :team_position
           ])
  end
end
