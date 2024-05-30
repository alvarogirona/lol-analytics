defmodule LolAnalytics.Dimensions.Player.PlayerRepo do
  import Ecto.Query

  alias LolAnalytics.Dimensions.Player.PlayerSchema
  alias LoLAnalytics.Repo

  def get_or_create(puuid) do
    query = from p in PlayerSchema, where: p.puuid == ^puuid
    player = Repo.one(query)

    case player do
      nil ->
        player_changeset =
          PlayerSchema.changeset(
            %PlayerSchema{},
            %{puuid: puuid}
          )
        Repo.insert(player_changeset)

      player ->
        player
    end
  end

  def list_players() do
    Repo.all(PlayerSchema)
  end
end
