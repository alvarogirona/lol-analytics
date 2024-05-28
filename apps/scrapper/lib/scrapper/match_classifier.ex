defmodule Scrapper.MatchClassifier do
  require Logger

  @spec classify_match(%LoLAPI.Model.MatchResponse{}) :: nil
  def classify_match(match = %LoLAPI.Model.MatchResponse{}) do
    classify_match_by_queue(match.info.queueId)
  end

  def stream_classify_matches_by_queue(queue \\ 420, bucket \\ "ranked") do
    Storage.MatchStorage.S3MatchStorage.stream_files("matches")
    |> Stream.each(fn match ->
      %{key: json_file} = match
      [key | _] = String.split(json_file, ".")

      response =
        HTTPoison.get!("http://#{System.get_env("EX_AWS_ENDPOINT")}:9000/matches/#{key}.json", [],
          timeout: 5000
        )

      %{"info" => %{"gameVersion" => gameVersion, "queueId" => queueId}} =
        Poison.decode!(response.body)

      if queueId == queue do
        Storage.MatchStorage.S3MatchStorage.store_match(key, response.body, bucket, gameVersion)
        Logger.info("Match #{key} processed")
      end

      match
    end)
  end

  @spec classify_match_by_queue(String.t()) :: nil
  def classify_match_by_queue("420") do
    matches = Storage.MatchStorage.S3MatchStorage.list_files("matches")
    total_matches = Enum.count(matches)

    matches
    |> Enum.with_index(fn match, index -> {match, index} end)
    |> Scrapper.Parallel.peach(fn {match, index} ->
      %{key: json_file} = match
      [key | _] = String.split(json_file, ".")

      response =
        HTTPoison.get!("http://#{System.get_env("EX_AWS_ENDPOINT")}:9000/matches/#{key}.json", [],
          timeout: 5000
        )

      %{"info" => %{"gameVersion" => gameVersion, "queueId" => queueId}} =
        Poison.decode!(response.body)

      if queueId == 420 do
        Storage.MatchStorage.S3MatchStorage.store_match(key, response.body, "ranked", gameVersion)
        Logger.info("Match at #{index} of #{total_matches} is classified")
      end

      match
    end)
  end

  def classify_match_by_queue(_) do
  end
end
