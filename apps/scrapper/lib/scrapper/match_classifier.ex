defmodule Scrapper.MatchClassifier do
  require Logger

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
end
