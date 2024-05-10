defmodule LolAnalytics.Analyzer.BaseAnalyzer do
  @callback analyze(:url, path :: String.t()) :: :ok
end
