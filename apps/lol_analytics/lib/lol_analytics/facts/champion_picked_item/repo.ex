defmodule LolAnalytics.Facts.ChampionPickedItem.Repo do
  import Ecto.Query

  alias LolAnalytics.Dimensions.Item.ItemSchema
  alias LolAnalytics.Dimensions.Champion.ChampionSchema
  alias LolAnalytics.Facts.ChampionPickedItem.Schema
  alias LolAnalytics.Dimensions.Item.ItemRepo
  alias LolAnalytics.Dimensions.Player.PlayerRepo
  alias LolAnalytics.Dimensions.Champion.ChampionRepo
  alias LolAnalytics.Dimensions.Match.MatchRepo
  alias LoLAnalytics.Repo

  @doc """
  Inserts a new entry for the campion_picked_item fact.

  Example:

  iex> item_picked = %{champion_id: 90, item_id: 1, match_id: "123", patch_number: "14.9", puuid: "1223", slot_number: 1, queue_id: 420, team_position: "JUNGLE", slot_number: 1, is_win: true}
  iex> LolAnalytics.Facts.ChampionPickedItem.Repo.insert(item_picked)
  """
  @spec insert(%{
          :champion_id => integer(),
          :item_id => integer(),
          :match_id => binary(),
          :patch_number => String.t(),
          :puuid => String.t(),
          :is_win => boolean(),
          :queue_id => integer(),
          :team_position => String.t(),
          :slot_number => integer()
        }) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def insert(attrs) do
    _match = MatchRepo.get_or_create(attrs.match_id)
    _champion = ChampionRepo.get_or_create(attrs.champion_id)
    _player = PlayerRepo.get_or_create(attrs.puuid)
    _patch = PlayerRepo.get_or_create(attrs.patch_number)
    _item_id = ItemRepo.get_or_create(attrs.item_id)

    prev =
      from(f in Schema,
        where:
          f.match_id == ^attrs.match_id and
            f.puuid == ^attrs.puuid and
            f.item_id == ^attrs.item_id and
            f.slot_number == ^attrs.slot_number
      )
      |> Repo.one()

    Schema.changeset(prev || %Schema{}, attrs)
    |> Repo.insert_or_update()
  end

  @spec get_champion_picked_items(String.t(), String.t()) :: list()
  def get_champion_picked_items(champion_id, team_position) do
    query =
      from f in Schema,
        where:
          f.champion_id == ^champion_id and
            f.team_position == ^team_position and
            f.item_id != 0,
        join: c in ChampionSchema,
        on: c.champion_id == f.champion_id,
        join: i in ItemSchema,
        on: i.item_id == f.item_id,
        select: %{
          wins: fragment("count(CASE WHEN ? THEN 1 END)", f.is_win),
          win_rate:
            fragment(
              "
              ((cast(count(CASE WHEN ? THEN 1 END) as float) / cast(count(*) as float)) * 100.0
              )",
              f.is_win
            ),
          item_id: i.item_id,
          champion_id: c.champion_id,
          team_position: f.team_position,
          total_games: count("*")
        },
        group_by: [
          i.item_id,
          c.champion_id,
          f.team_position
        ]

    Repo.all(query)
  end
end
