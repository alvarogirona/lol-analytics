defmodule LolAnalytics.Dimensions.Champion.ChampionMetadata do
  alias LolAnalytics.Dimensions.Champion.ChampionRepo
  @champions_data_url "https://ddragon.leagueoflegends.com/cdn/14.11.1/data/en_US/champion.json"

  use GenServer

  def update_metadata() do
    {:ok, %{"data" => data}} = get_champions()

    data
    |> Enum.each(&save_metadata/1)
  end

  defp get_champions() do
    with {:ok, resp} <- HTTPoison.get(@champions_data_url),
         data <- Poison.decode(resp.body) do
      data
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp save_metadata({champion, info}) do
    %{
      "image" => %{
        "full" => full_image
      },
      "name" => name,
      "key" => key_string
    } = info

    attrs = %{
      image: full_image,
      name: name
    }

    {champion_id, _} = Integer.parse(key_string)

    ChampionRepo.update(champion_id, attrs)

    info
  end
end
