defmodule LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameSchema do
  use Ecto.Schema

  schema "fact_champion_played_game" do
    field :champion_id, :integer
    field :match_id, :integer
    field :is_win, :boolean
    field :game_length_seconds, :integer
    field :queue_id, :integer
  end
end
