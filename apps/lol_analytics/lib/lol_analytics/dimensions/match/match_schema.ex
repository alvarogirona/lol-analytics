defmodule LolAnalytics.Dimensions.Match.MatchSchema do
  use Ecto.Schema
  import Ecto.Changeset

  @casting_attrs [
    :match_id,
    :queue_id,
    :patch_number,
    :fact_champion_picked_item_status,
    :fact_champion_picked_summoner_spell_status,
    :fact_champion_played_game_status
  ]

  schema "dim_match" do
    field :match_id, :string
    field :patch_number, :string
    field :queue_id, :integer
    field :fact_champion_picked_item_status, :integer
    field :fact_champion_picked_summoner_spell_status, :integer
    field :fact_champion_played_game_status, :integer
    timestamps()
  end

  def changeset(match = %__MODULE__{}, attrs \\ %{}) do
    match
    |> cast(attrs, @casting_attrs)
    |> validate_required([:match_id])
  end
end
