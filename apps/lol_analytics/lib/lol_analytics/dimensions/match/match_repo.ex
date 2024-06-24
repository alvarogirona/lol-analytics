defmodule LolAnalytics.Dimensions.Match.MatchRepo do
  alias LolAnalytics.Dimensions.Patch.PatchRepo
  alias LolAnalytics.Dimensions.Match.MatchSchema
  alias LoLAnalytics.Repo

  import Ecto.Query

  @spec get_or_create(%{
          :match_id => String.t(),
          :queue_id => integer(),
          :patch_number => String.t()
        }) :: %MatchSchema{}
  def get_or_create(%{match_id: match_id, queue_id: queue_id, patch_number: patch_number}) do
    _patch = PatchRepo.get_or_create(patch_number)
    query = from m in MatchSchema, where: m.match_id == ^match_id
    match = Repo.one(query)

    case match do
      nil ->
        %MatchSchema{}
        |> MatchSchema.changeset(%{
          match_id: match_id,
          patch_number: patch_number,
          queue_id: queue_id,
          fact_champion_played_game_status: 0,
          fact_champion_picked_item_status: 0,
          fact_champion_picked_summoner_spell_status: 0
        })
        |> Repo.insert!()

      match ->
        match
    end
  end

  @spec get(String.t()) :: nil | %MatchSchema{}
  def get(match_id) do
    query = from m in MatchSchema, where: m.match_id == ^match_id

    Repo.one(query)
  end

  @type update_attrs :: %{
          optional(:fact_champion_played_game_status) => process_status(),
          optional(:fact_champion_picked_item_status) => process_status(),
          optional(:fact_champion_picked_summoner_spell_status) => process_status()
        }
  @spec update(%MatchSchema{}, update_attrs()) :: %MatchSchema{}
  def update(match, attrs) do
    mapped_attrs =
      attrs
      |> Enum.map(fn {k, v} -> {k, process_status_atom_to_db(v)} end)
      |> Map.new()

    match
    |> MatchSchema.changeset(mapped_attrs)
    |> Repo.update!()
  end

  def list_matches() do
    Repo.all(MatchSchema)
  end

  @type process_status :: :not_processed | :processed | :error
  defp process_status_atom_to_db(:not_processed), do: 0
  defp process_status_atom_to_db(:enqueued), do: 1
  defp process_status_atom_to_db(:processed), do: 2
  defp process_status_atom_to_db(:error), do: 3
  defp process_status_atom_to_db(_), do: raise("Invalid processing status")
end
