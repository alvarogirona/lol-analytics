defmodule LolAnalytics.Dimensions.Item.ItemRepo do
  alias LolAnalytics.Dimensions.Item.ItemSchema
  alias LoLAnalytics.Repo

  def get_or_create(item_id) do
    item = Repo.get(ItemSchema, item_id: item_id)

    case item do
      nil ->
        item_changeset = ItemSchema.changeset(%ItemSchema{}, %{item_id: item_id})
        Repo.insert(item_changeset)

      item ->
        item
    end
  end

  def list_items() do
    Repo.all(ItemSchema)
  end
end
