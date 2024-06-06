defmodule LolAnalytics.Dimensions.SummonerSpell.SummonerSpellRepo do
  import Ecto.Query

  alias LolAnalytics.Dimensions.SummonerSpell.SummonerSpellSchema
  alias LoLAnalytics.Repo

  @spec get_or_create(String.t()) :: any()
  def get_or_create(spell_id) do
    query = from s in SummonerSpellSchema, where: s.spell_id == ^spell_id
    spell = Repo.one(query)

    case spell do
      nil ->
        spell_changeset =
          SummonerSpellSchema.changeset(
            %SummonerSpellSchema{},
            %{spell_id: spell_id}
          )

        Repo.insert(spell_changeset)

      spell ->
        spell
    end
  end

  @spec update(spell_id :: String.t(), attrs :: map()) :: any()
  def update(spell_id, attrs) do
    get_or_create(spell_id)
    |> SummonerSpellSchema.changeset(attrs)
    |> Repo.update()
  end

  def list_spells() do
    Repo.all(SummonerSpellSchema)
  end
end
