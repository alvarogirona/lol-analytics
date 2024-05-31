defmodule LolAnalyticsWeb.ChampionLive.Mapper do
  alias LolAnalyticsWeb.ChampionLive.Champion

  def map_champs(champs) do
    champs
    |> Enum.map(fn champ ->
      %{
        Kernel.struct!(%Champion{}, champ)
        | win_rate: :erlang.float_to_binary(champ.win_rate, decimals: 2)
      }
    end)
  end
end
