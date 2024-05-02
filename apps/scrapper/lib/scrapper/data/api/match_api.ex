defmodule Scrapper.Data.Api.MatchApi do
  @match_base_endpoint "https://europe.api.riotgames.com/lol/match/v5/matches/%{matchid}"
  @puuid_matches_base_endpoint "https://europe.api.riotgames.com/lol/match/v5/matches/by-puuid/%{puuid}/ids"

  @doc """
  Get match by id

  iex> Scrapper.Data.MatchApi.get_match_by_id("EUW1_6921743825")
  """
  @spec get_match_by_id(String.t()) :: %Scrapper.Data.Api.Model.Match.MatchResponse{}
  def get_match_by_id(match_id) do
    url = String.replace(@match_base_endpoint, "%{matchid}", match_id)
    api_key = System.get_env("RIOT_API_KEY")
    headers = [{"X-Riot-Token", api_key}]
    response = HTTPoison.get!(url, headers, timeout: 5000)

    case response.status_code do
      200 ->
        # process the response here
        response.body
        Poison.decode!(response.body, as: %Scrapper.Data.Api.Model.Match.MatchResponse{})

      _ ->
        # handle error responses
        IO.inspect(response.status_code)
    end
  end

  @spec get_matches_from_player(String.t()) :: list(String.t()) | integer()
  def get_matches_from_player(puuid) do
    url = String.replace(@puuid_matches_base_endpoint, "%{puuid}", puuid)
    api_key = System.get_env("RIOT_API_KEY")
    headers = [{"X-Riot-Token", api_key}]
    response = HTTPoison.get!(url, headers, timeout: 5000)

    case response.status_code do
      200 ->
        # process the response here
        IO.inspect(response.body)
        Poison.decode!(response.body)

      _ ->
        # handle error responses
        IO.inspect(response.status_code)
    end
  end
end
