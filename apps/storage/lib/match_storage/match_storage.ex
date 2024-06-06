defmodule Storage.MatchStorage do
  @callback stream_files(String.t()) :: Enumerable.t()
  @callback get_match(String.t()) :: {:ok, Scrapper.Data.Match.t()} | {:error, :not_found}
  @callback store_match(match_id :: String.t(), match_data :: String.t(), path :: String.t()) ::
              String.t()
  @callback store_match(
              match_id :: String.t(),
              match_data :: String.t(),
              bucket :: String.t(),
              path :: String.t()
            ) ::
              String.t()
end
