import Config

config :scrapper,
  riot_api_key: System.get_env("RIOT_API_KEY")

import_config "#{config_env()}.exs"
