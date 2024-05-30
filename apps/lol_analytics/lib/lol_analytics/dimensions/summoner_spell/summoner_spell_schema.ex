defmodule LolAnalytics.Dimensions.SummonerSpell.SummonerSpellSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dim_summoner_spell" do
    field :spell_id, :integer
    timestamps()
  end

  def changeset(summoner_spell = %__MODULE__{}, attrs) do
    summoner_spell
    |> cast(attrs, [:spell_id])
    |> validate_required([:spell_id])
  end
end
