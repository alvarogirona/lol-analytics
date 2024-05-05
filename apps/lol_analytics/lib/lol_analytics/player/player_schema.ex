defmodule LolAnalytics.Player.PlayerSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "player" do
    field :puuid, :string
    field :region, :string

    field :last_processed_at, :utc_datetime,
      default: DateTime.utc_now() |> DateTime.truncate(:second)

    timestamps()
  end

  @spec changeset(%__MODULE__{}) ::
          Ecto.Changeset.t()
  def changeset(player = %__MODULE__{}, params \\ %{}) do
    player
    |> cast(params, [:puuid, :region, :last_processed_at])
    |> validate_required([:puuid, :region, :last_processed_at])
    |> unique_constraint(:puuid)
  end
end
