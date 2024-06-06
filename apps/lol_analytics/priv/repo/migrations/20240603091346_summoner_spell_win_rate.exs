defmodule LoLAnalytics.Repo.Migrations.SummonerSpellWinRate do
  use Ecto.Migration

  def change do
    create table("fact_champion_picked_summoner_spell") do
      add :champion_id, references("dim_champion", column: :champion_id, type: :integer)
      add :summoner_spell_id, references("dim_summoner_spell", column: :spell_id, type: :integer)
      add :match_id, references("dim_match", column: :match_id, type: :string)
      add :is_win, :boolean
      add :game_length_seconds, :integer
      add :queue_id, :integer
      add :team_position, :string
      add :puuid, references("dim_player", column: :puuid, type: :string)
      add :patch_number, references("dim_patch", column: :patch_number, type: :string)
    end

    create index(
             "fact_champion_picked_summoner_spell",
             [:puuid, :match_id, :summoner_spell_id],
             unique: true
           )

    create index("fact_champion_picked_summoner_spell", [
             :is_win,
             :team_position,
             :queue_id,
             :summoner_spell_id,
             :patch_number
           ])
  end
end
