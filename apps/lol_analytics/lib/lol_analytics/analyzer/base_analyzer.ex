defmodule LolAnalytics.Analyzer do
  @callback analyze(:url, path :: String.t()) :: :ok
end
