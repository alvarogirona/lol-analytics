defmodule LolAnalytics.Facts.ChampionPickedSummonerSpell.Repo do
  import Ecto.Query

  alias LolAnalytics.Dimensions.SummonerSpell.SummonerSpellRepo
  alias LolAnalytics.Dimensions.Champion.ChampionSchema

  alias LolAnalytics.Facts.ChampionPickedSummonerSpell.Schema

  alias LolAnalytics.Dimensions.Player.PlayerRepo
  alias LolAnalytics.Dimensions.Champion.ChampionRepo
  alias LolAnalytics.Dimensions.Match.MatchRepo

  alias LoLAnalytics.Repo

  @type insert_attrs :: %{
    match_id: String.t(),
    champion_id: String.t(),
    puuid: String.t(),
    summoner_spell_id: :integer
  }

  @spec insert(insert_attrs()) :: any()
  def insert(attrs) do
    _match = MatchRepo.get_or_create(attrs.match_id)
    _champion = ChampionRepo.get_or_create(attrs.champion_id)
    _player = PlayerRepo.get_or_create(attrs.puuid)
    _spell = SummonerSpellRepo.get_or_create(attrs.summoner_spell_id)
    changeset = Schema.changeset(%Schema{}, attrs)

    IO.inspect(attrs)

    Repo.insert(changeset)
    |> IO.inspect()
  end

  def get_champion_picked_summoners() do
    query =
      from f in Schema,
        join: c in ChampionSchema,
        on: c.champion_id == f.champion_id,
        select: %{
          wins: fragment("count(CASE WHEN ? THEN 1 END)", f.is_win),
          win_rate:
            fragment(
              "
              ((cast(count(CASE WHEN ? THEN 1 END) as float) / cast(count(*) as float)) * 100.0
              )",
              f.is_win
            ),
          id: f.champion_id,
          spell_id: f.spell_id,
          name: c.name,
          image: c.image,
          team_position: f.team_position,
          total_games: count("*")
        },
        group_by: [f.champion_id, f.spell_id, c.image, c.name, f.team_position]

    Repo.all(query)
  end

  def list_facts() do
    Repo.all(Schema)
  end
end
