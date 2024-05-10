defmodule LoLAPI.MatchApi do
  require Logger
  @match_base_endpoint "https://europe.api.riotgames.com/lol/match/v5/matches/%{matchid}"
  @puuid_matches_base_endpoint "https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/%{puuid}/ids"

  @doc """
  Get match by id

  iex> LoLAPI.MatchApi.get_match_by_id("EUW1_6921743825")
  """
  @spec get_match_by_id(String.t()) :: %LoLAPI.Model.MatchResponse{}
  def get_match_by_id(match_id) do
    url = String.replace(@match_base_endpoint, "%{matchid}", match_id)
    Logger.info("Making request to #{url}")
    api_key = System.get_env("RIOT_API_KEY")
    headers = [{"X-Riot-Token", api_key}]
    response = HTTPoison.get!(url, headers, timeout: 5000)

    case response.status_code do
      200 ->
        {:ok, response.body}

      _ ->
        Logger.error("Error getting match by id: #{match_id} #{inspect(response)}")
        {:err, response.status_code}
    end
  end

  @doc """
  Get matches from player

  iex> LoLAPI.MatchApi.get_matches_from_player "JB6TdEWlKjZwnbgdSzOogYepNfjLPdUh68S8b4kUu4EEZy4R4MMAgv92QMj1XgVjtzHmZVLaOW7mzg"
  """
  @spec get_matches_from_player(String.t()) :: list(String.t()) | integer()
  def get_matches_from_player(puuid) do
    url = String.replace(@puuid_matches_base_endpoint, "%{puuid}", URI.encode(puuid))
    Logger.info("Making request to #{url}")
    api_key = System.get_env("RIOT_API_KEY")
    headers = [{"X-Riot-Token", api_key}]
    response = HTTPoison.get!(url, headers, timeout: 5000)

    case response.status_code do
      200 ->
        {:ok, Poison.decode!(response.body)}

      code ->
        Logger.error("Error getting matches from player #{puuid} #{code}")
        {:err, response.status_code}
    end
  end
end
