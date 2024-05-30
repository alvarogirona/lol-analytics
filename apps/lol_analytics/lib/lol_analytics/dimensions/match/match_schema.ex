defmodule LolAnalytics.Dimensions.Match.MatchSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dim_match" do
    field :match_id, :string
    timestamps()
  end

  def changeset(match = %__MODULE__{}, attrs \\ %{}) do
    match
    |> cast(attrs, [:match_id])
    |> validate_required([:match_id])
  end
end
