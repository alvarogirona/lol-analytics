defmodule LolAnalytics.Dimensions.Item.ItemSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dim_item" do
    field :item_id, :integer
    timestamps()
  end

  def changeset(item = %__MODULE__{}, attrs \\ %{}) do
    item
    |> cast(attrs, [:item_id])
    |> validate_required([:item_id])
  end
end
