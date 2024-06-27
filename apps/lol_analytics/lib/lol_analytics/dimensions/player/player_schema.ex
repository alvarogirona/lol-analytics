defmodule LolAnalytics.Dimensions.Player.PlayerSchema do
  use Ecto.Schema
  import Ecto.Changeset

  @attrs [:puuid, :last_processed_at]

  schema "dim_player" do
    field :puuid, :string

    field :last_processed_at, :utc_datetime,
      default: DateTime.utc_now() |> DateTime.truncate(:second)

    timestamps()
  end

  def changeset(player = %__MODULE__{}, attrs \\ %{}) do
    player
    |> cast(attrs, @attrs)
    |> validate_required([:puuid])
    |> unique_constraint([:puuid])
  end
end
