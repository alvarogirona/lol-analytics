defmodule LoLAnalytics.Repo.Migrations.Match do
  use Ecto.Migration

  def change do
    create table("match", id: false) do
      add :match_id, :string, primary_key: true
      add :processed, :boolean
      timestamps()
    end

    create index("match", [:processed])
  end
end
