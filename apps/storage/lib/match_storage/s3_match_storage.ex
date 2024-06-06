defmodule Storage.MatchStorage.S3MatchStorage do
  require Logger
  @behaviour Storage.MatchStorage

  @impl true
  def get_match(_match_id) do
  end

  @impl true
  def stream_files(path) do
    ExAws.S3.list_objects_v2(path)
    |> ExAws.stream!()
  end

  @doc """
  iex> Scrapper.Storage.S3MatchStorage.store_match "1", "content", "matches"
  """
  @impl true
  @spec store_match(String.t(), String.t(), String.t()) :: none()
  def store_match(match_id, match_data, bucket) do
    File.write("/tmp/#{match_id}.json", match_data)

    url =
      "/tmp/#{match_id}.json"
      |> ExAws.S3.Upload.stream_file()
      |> ExAws.S3.upload(bucket, "#{match_id}.json")
      |> ExAws.request!()
      |> extract_s3_url_from_upload

    Logger.info("Stored match at #{url}")

    url
  end

  @doc """
  iex> Scrapper.Storage.S3MatchStorage.store_match "1", "content", "ranked" "14.9"
  """
  @impl true
  @spec store_match(String.t(), String.t(), String.t(), String.t()) :: none()
  def store_match(match_id, match_data, bucket, path) do
    File.write("/tmp/#{match_id}.json", match_data)

    url =
      "/tmp/#{match_id}.json"
      |> ExAws.S3.Upload.stream_file()
      |> ExAws.S3.upload("#{bucket}/#{path}", "#{match_id}.json")
      |> ExAws.request!()
      |> extract_s3_url_from_upload

    Logger.info("Stored match at #{url}")

    url
  end

  defp extract_s3_url_from_upload(%{:body => %{:location => location}} = _s3_response),
    do: location
end
