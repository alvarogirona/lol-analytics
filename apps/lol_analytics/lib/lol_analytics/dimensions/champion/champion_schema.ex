defmodule LolAnalytics.Dimensions.Champion.ChampionSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dim_champion" do
    field :champion_id, :integer
    field :name, :string
    field :image, :string
    timestamps()
  end

  def changeset(champion = %__MODULE__{}, attrs \\ %{}) do
    champion
    |> cast(attrs, [:champion_id, :name, :image])
    |> validate_required([:champion_id])
  end
end
