defmodule Scrapper.Data.Api.Model.Match.MatchResponse do
  alias Scrapper.Data.Api.Model.Match.{Info, Metadata}

  defstruct metadata: %Metadata{},
            info: %Info{}
end
