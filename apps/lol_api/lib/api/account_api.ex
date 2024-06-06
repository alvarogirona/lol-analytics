defmodule LoLAPI.AccountApi do
  require Logger

  @get_puuid_endpoint "https://europe.api.riotgames.com/riot/account/v1/accounts/by-riot-id/%{gameName}/%{tagLine}"

  @spec get_puuid(String.t(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def get_puuid(name, tag) do
    url =
      @get_puuid_endpoint
      |> String.replace("%{gameName}", name)
      |> String.replace("%{tagLine}", tag)

    api_key = System.get_env("RIOT_API_KEY")
    headers = [{"X-Riot-Token", api_key}]
    response = HTTPoison.get!(url, headers, timeout: 5000)

    case response.status_code do
      200 ->
        {:ok, Poison.decode(response.body)}

      _code ->
        Logger.error("Error getting puuid from player #{name} \##{tag}")
        {:err, response.status_code}
    end
  end
end
