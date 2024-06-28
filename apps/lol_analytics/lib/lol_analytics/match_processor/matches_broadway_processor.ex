defmodule LolAnalytics.MatchProcessor.MatchesBroadwayProcessor do
  alias LolAnalytics.Facts.FactsRunner
  use Broadway

  def start_link(opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      processors: [default: []],
      producer: [
        module: {LolAnalytics.MatchProcessor.MatchesProducer, []},
        rate_limiting: [
          interval: 1000,
          allowed_messages: 40
        ]
      ]
    )
  end

  @impl Broadway
  def handle_message(_processor, message, _context) do
    message.data
    # build_match_url(message.data.queue_id, message.data.patch_number, message.data.match_id)
    |> FactsRunner.analyze_match()

    message
  end

  defp build_match_url(queue, patch_id, match_id) do
    "http://192.168.1.55:9000/#{queue_to_dir(queue)}/#{patch_id}/#{match_id}.json"
  end

  defp queue_to_dir(420), do: "ranked"
  defp queue_to_dir(_), do: "ranked"
end
