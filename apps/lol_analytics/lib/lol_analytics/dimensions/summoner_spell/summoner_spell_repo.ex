defmodule LolAnalytics.Dimensions.SummonerSpell.SummonerSpellRepo do
  import Ecto.Query

  alias LolAnalytics.Dimensions.SummonerSpell.SummonerSpellSchema
  alias LoLAnalytics.Repo

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

  def list_spells() do
    Repo.all(SummonerSpellSchema)
  end
end
