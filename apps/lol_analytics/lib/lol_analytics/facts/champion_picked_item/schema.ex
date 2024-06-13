defmodule LolAnalytics.Facts.ChampionPickedItem.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  @casting_args [
    :champion_id,
    :item_id,
    :match_id,
    :is_win,
    :queue_id,
    :patch_number,
    :team_position,
    :puuid,
    :slot_number
  ]

  schema "fact_champion_picked_item" do
    field :champion_id, :integer
    field :item_id, :integer
    field :match_id, :string
    field :is_win, :boolean
    field :queue_id, :integer
    field :patch_number, :string
    field :team_position, :string
    field :puuid, :string
    field :slot_number, :integer
  end

  def changeset(fact, attrs) do
    fact
    |> cast(attrs, @casting_args)
    |> validate_required(@casting_args)
  end
end
