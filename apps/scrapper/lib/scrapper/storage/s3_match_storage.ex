defmodule Scrapper.Storage.S3MatchStorage do
  require Logger
  import SweetXml

  @behaviour Scrapper.Data.Storage.MatchStorage

  def get_match(match_id) do
    ""
  end

  @doc """

  iex> Scrapper.Storage.S3MatchStorage.store_match "1", "content"
  """
  @spec store_match(String.t(), String.t()) :: none()
  def store_match(match_id, match_data) do
    File.write("/tmp/#{match_id}.json", match_data)

    url =
      "/tmp/#{match_id}.json"
      |> ExAws.S3.Upload.stream_file()
      |> ExAws.S3.upload("matches", "#{match_id}.json")
      |> ExAws.request!()
      |> extract_s3_url_from_upload

    Logger.info("Stored match at #{url}")

    url
  end

  defp extract_s3_url_from_upload(%{:body => %{:location => location}} = _s3_response),
    do: location
end
