defmodule Storage.MatchStorage.S3MatchStorage do
  require Logger
  @behaviour Storage.MatchStorage

  def get_match(match_id) do
    ""
  end

  # check for to get all pages next_continuation_token
  @impl true
  def list_matches() do
    {:ok, %{:body => %{:contents => contents, next_continuation_token: next_continuation_token}}} =
      ExAws.S3.list_objects_v2("matches")
      |> ExAws.request()

    if next_continuation_token do
      list_matches(contents, next_continuation_token)
      # |> Enum.map(fn %{key: key} -> key end)
    else
      contents
      # |> Enum.map(fn %{key: key} -> key end)
    end
  end

  @spec list_matches(list(String.t()), String.t()) :: list(String.t())
  defp list_matches(acc, continuation_token) do
    resp =
      {:ok,
       %{:body => %{:contents => contents, next_continuation_token: next_continuation_token}}} =
      ExAws.S3.list_objects_v2("matches", continuation_token: continuation_token)
      |> ExAws.request()

    if next_continuation_token == "" do
      acc ++ contents
    else
      list_matches(acc ++ contents, next_continuation_token)
    end
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
