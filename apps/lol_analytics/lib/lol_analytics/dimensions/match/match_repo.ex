defmodule LolAnalytics.Dimensions.Match.MatchRepo do
  alias LolAnalytics.Dimensions.Match.MatchSchema
  alias LoLAnalytics.Repo

  import Ecto.Query

  @spec get_or_create(String.t()) :: %MatchSchema{}
  def get_or_create(match_id) do
    query = from m in MatchSchema, where: m.match_id == ^match_id
    match = Repo.one(query)

    case match do
      nil ->
        match_changeset =
          MatchSchema.changeset(
            %MatchSchema{},
            %{match_id: match_id}
          )

        Repo.insert(match_changeset)

      match ->
        match
    end
  end

  def list_matches() do
    Repo.all(MatchSchema)
  end
end
