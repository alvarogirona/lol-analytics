defmodule LolAnalyticsWeb.ChampionLive.Mapper do
  alias LolAnalyticsWeb.ChampionLive.ChampionSummary

  def map_champs(champs) do
    champs
    |> Enum.map(fn champ ->
      %{
        champ
        | win_rate: :erlang.float_to_binary(champ.win_rate, decimals: 2)
      }
    end)
  end
end
