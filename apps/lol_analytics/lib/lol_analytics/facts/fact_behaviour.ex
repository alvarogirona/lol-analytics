defmodule LolAnalytics.Facts.FactBehaviour do
  @callback process_game_at_url(String.t()) :: any()
end
