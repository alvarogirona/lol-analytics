defmodule LoLAPI.Model.MatchResponse do
  alias LoLAPI.Model.{Info, Metadata}

  defstruct metadata: %Metadata{},
            info: %Info{}
end
