defmodule Scrapper.Data.Storage.MatchStorage do
  @callback get_match(String.t()) :: {:ok, Scrapper.Data.Match.t()} | {:error, :not_found}
  @callback save_match(String.t(), Scrapper.Data.Match.t()) :: :ok
end
