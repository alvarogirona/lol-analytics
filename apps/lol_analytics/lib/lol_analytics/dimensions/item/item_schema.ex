defmodule LolAnalytics.Dimensions.Item.ItemSchema do
  use Ecto.Schema
  import Ecto.Changeset

  @args [:item_id, :metadata]

  schema "dim_item" do
    field :item_id, :integer
    field :metadata, :map
    timestamps()
  end

  def changeset(item = %__MODULE__{}, attrs \\ %{}) do
    item
    |> cast(attrs, @args)
    |> validate_required([:item_id])
  end
end
