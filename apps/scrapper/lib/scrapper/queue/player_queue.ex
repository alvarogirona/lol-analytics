defmodule Scrapper.Queue.PlayerQueue do
  require Logger
  use GenServer

  @hours_to_update_player 12

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, {}, name: __MODULE__)
  end

  @spec init(any()) :: {:ok, {AMQP.Channel.t(), AMQP.Connection.t()}}
  def init(_opts) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Queue.declare(channel, "player",
      durable: true,
      arguments: [{"x-max-length", :long, 1000}]
    )

    {:ok, {channel, connection}}
  end

  @spec enqueue_puuid(String.t()) :: nil
  def enqueue_puuid(puuid) do
    case LolAnalytics.Player.PlayerRepo.get_player(puuid) do
      nil -> GenServer.call(__MODULE__, {:enqueue_player, puuid})
      player_entry -> enqueue_if_not_updated?(player_entry)
    end
  end

  @spec enqueue_if_not_updated?(%LolAnalytics.Player.PlayerSchema{}) :: nil
  defp enqueue_if_not_updated?(player = %LolAnalytics.Player.PlayerSchema{}) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    case player.last_processed_at do
      nil ->
        GenServer.call(__MODULE__, {:enqueue_player, player.puuid})

      processed_at ->
        diff_in_hours = DateTime.diff(now, processed_at, :hour)

        if diff_in_hours > @hours_to_update_player do
          GenServer.call(__MODULE__, {:enqueue_player, player.puuid})
        else
          Logger.info(
            "Player #{player.puuid} already processed at #{player.last_processed_at}, diff was #{diff_in_hours}"
          )
        end
    end
  end

  def handle_call({:enqueue_player, puuid}, _from, {channel, _} = state) do
    LolAnalytics.Player.PlayerRepo.insert_player(puuid)
    AMQP.Basic.publish(channel, "", "player", puuid)
    {:reply, nil, state}
  end
end
