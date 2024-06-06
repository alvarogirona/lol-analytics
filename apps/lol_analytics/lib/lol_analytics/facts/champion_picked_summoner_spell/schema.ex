defmodule LolAnalytics.Facts.ChampionPickedSummonerSpell.Schema do
  use Ecto.Schema

  import Ecto.Changeset

  @params [
    :champion_id,
    :summoner_spell_id,
    :match_id,
    :is_win,
    :game_length_seconds,
    :queue_id,
    :team_position,
    :puuid
  ]

  schema "fact_champion_picked_summoner_spell" do
    field :champion_id, :integer
    field :summoner_spell_id, :integer
    field :match_id, :string
    field :is_win, :boolean
    field :game_length_seconds, :integer
    field :queue_id, :integer
    field :team_position, :string
    field :puuid, :string
  end

  def changeset(fact = %__MODULE__{}, attrs \\ %{}) do
    fact
    |> cast(attrs, @params)
    |> validate_required(@params)
    |> unique_constraint([:puuid, :match_id, :summoner_spell_id])
  end
end
