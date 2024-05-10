defmodule LolAnalytics.Player.PlayerRepo do
  alias LolAnalytics.Player.PlayerSchema

  import Ecto.Query

  def list_players do
    query = from p in PlayerSchema, order_by: [desc: p.id]
    LoLAnalytics.Repo.all(query)
  end

  def number_of_players do
    query = from p in PlayerSchema, select: count(p.id)
    LoLAnalytics.Repo.one(query)
  end

  def get_player(puuid) do
    query = from p in PlayerSchema, where: p.puuid == ^puuid

    LoLAnalytics.Repo.all(query)
    |> List.first()
  end

  @spec insert_player(String.t(), keyword()) :: %PlayerSchema{}
  def insert_player(puuid, attrs \\ %{}) do
    attrs = Map.merge(%{puuid: puuid, region: "EUW", status: "queued"}, attrs)

    %PlayerSchema{}
    |> PlayerSchema.changeset(attrs)
    |> LoLAnalytics.Repo.insert()
  end

  def update_player(player, attrs) do
    player
    |> PlayerSchema.changeset(attrs)
    |> LoLAnalytics.Repo.update()
  end
end
