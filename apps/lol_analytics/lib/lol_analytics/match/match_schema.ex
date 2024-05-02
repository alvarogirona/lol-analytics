defmodule LolAnalytics.Match.MatchSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "match" do
    field :match_id, :string
    field :processed, :boolean, default: false

    timestamps()
  end

  def changeset(%__MODULE__{} = match, params \\ %{}) do
    match
    |> cast(params, [:match_id, :processed])
    |> validate_required([:match_id, :processed])
  end

end
