defmodule Scrapper.Data.Model.Match.MatchResponse do
  alias Scrapper.Data.Model.Match.Info
  alias Scrapper.Data.Model.Match.Metadata

  defstruct metadata: %Metadata{},
            info: %Info{}
end
