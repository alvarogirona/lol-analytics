defmodule Storage.MatchStorage do
  @callback get_match(String.t()) :: {:ok, Scrapper.Data.Match.t()} | {:error, :not_found}
  @callback save_match(String.t(), Scrapper.Data.Match.t()) :: :ok
  @callback list_matches() :: [map()]
  @callback store_match(match_id :: String.t(), match :: map(), path :: String.t()) :: String.t()
end
