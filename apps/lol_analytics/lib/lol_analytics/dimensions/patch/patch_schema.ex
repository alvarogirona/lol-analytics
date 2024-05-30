defmodule LolAnalytics.Dimensions.Patch.PatchSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dim_patch" do
    field :patch_number, :string
    timestamps()
  end

  def changeset(patch = %__MODULE__{}, attrs \\ %{}) do
    patch
    |> cast(attrs, [:patch_number])
    |> validate_required([:patch_number])
  end
end
