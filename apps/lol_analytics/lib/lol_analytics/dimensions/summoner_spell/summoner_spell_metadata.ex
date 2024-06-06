defmodule LolAnalytics.Dimensions.SummonerSpell.SummonerSpellMetadata do
  alias LolAnalytics.Dimensions.SummonerSpell.SummonerSpellRepo
  @spells_url "https://ddragon.leagueoflegends.com/cdn/14.11.1/data/en_US/summoner.json"

  def update_metadata() do
    get_spells()
    |> Enum.each(&save_metadata/1)
  end

  defp get_spells() do
    case HTTPoison.get(@spells_url) do
      {:ok, resp} ->
        Poison.decode!(resp.body)["data"]
    end
  end

  defp save_metadata({name, metadata}) do
    %{"key" => spell_id} = metadata

    SummonerSpellRepo.update(spell_id, %{metadata: metadata})
  end
end
