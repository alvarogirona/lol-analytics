defmodule LolAnalytics.ChampionWinRate.ChampionWinRateSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "champion_win_rate" do
    field :champion_id, :integer
    field :total_games, :integer
    field :patch, :string
    field :position, :string
    field :total_wins, :integer

    timestamps()
  end

  def changeset(%__MODULE__{} = champion_win_rate, attrs) do
    champion_win_rate
    |> cast(attrs, [:champion_id, :total_games, :patch, :total_wins, :position])
    |> validate_required([:champion_id, :total_games, :patch, :total_wins, :position])
  end
end
