defmodule LoLAnalytics.Repo.Migrations.MatchAndPlayerStatus do
  use Ecto.Migration

  def change do
    alter table("match") do
      add :status, :string, default: "processed"
    end

    alter table("player") do
      add :status, :string, default: "processed"
    end
  end
end
