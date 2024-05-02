defmodule Scrapper.Api.Model.MatchResponse do
  alias Scrapper.Api.Model.{Info, Metadata}

  defstruct metadata: %Metadata{},
            info: %Info{}
end
