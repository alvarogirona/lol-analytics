defmodule LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameRepo do
  import Ecto.Query

  alias LolAnalytics.Dimensions.Player.PlayerRepo
  alias LolAnalytics.Dimensions.Champion.ChampionRepo
  alias LolAnalytics.Dimensions.Match.MatchRepo
  alias LolAnalytics.Facts.ChampionPlayedGame.ChampionPlayedGameSchema
  alias LolAnalytics.Facts.ChampionPlayedGame
  alias LoLAnalytics.Repo

  def insert(attrs) do
    match = MatchRepo.get_or_create(attrs.match_id)
    champion = ChampionRepo.get_or_create(attrs.champion_id)
    player = PlayerRepo.get_or_create(attrs.puuid)
    IO.puts(">>>>")
    IO.inspect(attrs)
    changeset = ChampionPlayedGameSchema.changeset(%ChampionPlayedGameSchema{}, attrs)

    IO.inspect(changeset)
    Repo.insert(changeset)
    # Repo.insert(match)
  end

  def list_played_matches() do
    Repo.all(ChampionPlayedGameSchema)
  end
end
