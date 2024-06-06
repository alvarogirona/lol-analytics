defmodule LolAnalytics.Dimensions.Champion.ChampionRepo do
  alias LoLAnalytics.Repo
  alias LolAnalytics.Dimensions.Champion.ChampionSchema

  @spec get_or_create(String.t()) :: struct()
  def get_or_create(champion_id) do
    champion = Repo.get_by(ChampionSchema, champion_id: champion_id)

    case champion do
      nil ->
        changeset = ChampionSchema.changeset(%ChampionSchema{}, %{champion_id: champion_id})
        Repo.insert(changeset)

      champion ->
        champion
    end
  end

  def update(champion_id, attrs) do
    get_or_create(champion_id)
    |> ChampionSchema.changeset(attrs)
    |> Repo.update()
  end

  @spec list_champions() :: any()
  def list_champions() do
    Repo.all(ChampionSchema)
  end
end
