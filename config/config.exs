# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :lol_analytics,
  namespace: LoLAnalytics,
  ecto_repos: [LoLAnalytics.Repo]

config :lol_analytics, LoLAnalytics.Repo, loggers: [], log: false

config :lol_analytics_web,
  namespace: LoLAnalyticsWeb,
  ecto_repos: [LoLAnalytics.Repo],
  generators: [context_app: :lol_analytics]

# Configures the endpoint
config :lol_analytics_web, LoLAnalyticsWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: LoLAnalyticsWeb.ErrorHTML, json: LoLAnalyticsWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: LoLAnalytics.PubSub,
  live_view: [signing_salt: "P44PwR+j"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  lol_analytics_web: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/lol_analytics_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  lol_analytics_web: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/lol_analytics_web/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
import_config "../apps/scrapper/config/config.exs"
import_config "../apps/storage/config/config.exs"
import_config "../apps/lol_api/config/config.exs"
