defmodule LolAnalytics.Dimensions.Item.ItemRepo do
  alias LolAnalytics.Dimensions.Item.ItemSchema
  alias LoLAnalytics.Repo

  import Ecto.Query

  def get_or_create(item_id) do
    query = from i in ItemSchema, where: i.item_id == ^item_id

    case Repo.one(query) do
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
