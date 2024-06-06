defmodule LolAnalytics.Facts.ChampionPlayedGame.Schema do
  use Ecto.Schema

  import Ecto.Changeset

  @casting_attrs [
    :champion_id,
    :match_id,
    :is_win,
    :game_length_seconds,
    :team_position,
    :puuid,
    :queue_id
  ]

  schema "fact_champion_played_game" do
    field :champion_id, :integer
    field :match_id, :string
    field :is_win, :boolean
    field :game_length_seconds, :integer
    field :team_position, :string
    field :puuid, :string
    field :queue_id, :integer
    timestamps()
  end

  def changeset(fact = %__MODULE__{}, attrs \\ %{}) do
    fact
    |> cast(attrs, @casting_attrs)
    |> validate_required(@casting_attrs)
    |> unique_constraint([:id, :champion_id, :queue_id])
  end
end
