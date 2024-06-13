defmodule LolAnalytics.Dimensions.Item.ItemMetadata do
  alias LolAnalytics.Dimensions.Item.ItemRepo
  alias LolAnalytics.Dimensions.Champion.ChampionRepo
  @items_data_url "https://ddragon.leagueoflegends.com/cdn/14.11.1/data/en_US/item.json"

  def update_metadata() do
    data = get_items()

    data
    # |> IO.inspect()
    |> Enum.each(&save_metadata/1)
  end

  defp get_items() do
    with {:ok, resp} <- HTTPoison.get(@items_data_url),
         %{"data" => data} <- Poison.decode!(resp.body) do
      data
    else
      _ -> {:error, :get_items_error}
    end
  end

  defp save_metadata({item_id, metadata}) do
    # IO.inspect(item)
    ItemRepo.update(item_id, %{metadata: metadata})
  end
end
