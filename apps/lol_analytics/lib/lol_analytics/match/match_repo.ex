defmodule LolAnalytics.Match.MatchRepo do
  alias LolAnalytics.Match.MatchSchema

  import Ecto.Query

  def list_matches do
    query = from m in MatchSchema, order_by: [desc: m.match_id]
    LoLAnalytics.Repo.all(query)
  end

  def number_of_matches do
    query = from m in MatchSchema, select: count(m.match_id)
    LoLAnalytics.Repo.one(query)
  end

  @spec get_match(String.t()) :: %LolAnalytics.Match.MatchSchema{} | nil
  def get_match(match_id) do
    query = from m in MatchSchema, where: m.match_id == ^match_id

    LoLAnalytics.Repo.one(query)
  end

  @spec insert_match(String.t()) :: %LolAnalytics.Match.MatchSchema{}
  def insert_match(match_id) do
    MatchSchema.changeset(%MatchSchema{}, %{:match_id => match_id, :processed => false})
    |> LoLAnalytics.Repo.insert()
  end

  @spec update_match(%LolAnalytics.Match.MatchSchema{}, term()) ::
          %LolAnalytics.Match.MatchSchema{}
  def update_match(match, attrs) do
    match = MatchSchema.changeset(match, attrs)
    LoLAnalytics.Repo.update(match)
  end
end
