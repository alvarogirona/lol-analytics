defmodule LoLAnalytics.Repo do
  use Ecto.Repo,
    otp_app: :lol_analytics,
    adapter: Ecto.Adapters.Postgres
end
