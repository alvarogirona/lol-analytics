defmodule LolAnalytics.Player.PlayerRepo do
  alias LolAnalytics.Player.PlayerSchema

  import Ecto.Query

  def list_players do
    query = from(p in PlayerSchema)
    LoLAnalytics.Repo.all(query)
  end

  def get_player(puuid) do
    query = from p in PlayerSchema, where: p.puuid == ^puuid
    LoLAnalytics.Repo.one(query)
  end

  def insert_player(puuid) do
    %PlayerSchema{}
    |> PlayerSchema.changeset(%{puuid: puuid, region: "EUW"})
    |> LoLAnalytics.Repo.insert()
  end

  def update_player(player, attrs) do
    player
    |> PlayerSchema.changeset(attrs)
    |> LoLAnalytics.Repo.update()
  end
end
