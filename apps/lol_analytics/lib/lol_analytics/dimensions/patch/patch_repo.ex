defmodule LolAnalytics.Dimensions.Patch.PatchRepo do
  alias LolAnalytics.Dimensions.Patch.PatchSchema
  alias LoLAnalytics.Repo

  def get_or_create(patch_number) do
    patch = Repo.get(PatchSchema, patch_number: patch_number)

    case patch do
      nil ->
        patch_changeset =
          PatchSchema.changeset(
            %PatchSchema{},
            %{patch_number: patch_number}
          )

        Repo.insert(patch_changeset)

      patch ->
        patch
    end
  end

  def list_patches() do
    Repo.all(PatchSchema)
  end
end
