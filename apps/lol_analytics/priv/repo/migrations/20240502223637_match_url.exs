defmodule LoLAnalytics.Repo.Migrations.MatchUrl do
  use Ecto.Migration

  def change do
    alter table("match") do
      add :match_url, :string
    end
  end
end
