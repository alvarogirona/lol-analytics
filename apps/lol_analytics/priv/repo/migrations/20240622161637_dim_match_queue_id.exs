defmodule LoLAnalytics.Repo.Migrations.DimMatchQueueId do
  use Ecto.Migration

  def change do
    alter table "dim_match" do
      add :queue_id, :integer
    end
  end
end
