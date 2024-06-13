defmodule LolAnalytics.Dimensions.Player.PlayerSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dim_player" do
    field :puuid, :string
    timestamps()
  end

  def changeset(player = %__MODULE__{}, attrs \\ %{}) do
    player
    |> cast(attrs, [:puuid])
    |> validate_required([:puuid])
    |> unique_constraint([:puuid])
  end
end
