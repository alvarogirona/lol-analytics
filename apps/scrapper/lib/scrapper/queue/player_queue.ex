defmodule Scrapper.Queue.PlayerQueue do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, {}, name: __MODULE__)
  end

  @spec init(any()) :: {:ok, {AMQP.Channel.t(), AMQP.Connection.t()}}
  def init(_opts) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    {:ok, {channel, connection}}
  end

  @spec queue_player(String.t()) :: nil
  def queue_player(puuid) do
    GenServer.call(__MODULE__, {:queue_player, puuid})
  end

  def handle_call({:queue_player, puuid}, _from, {channel, _} = state) do
    AMQP.Basic.publish(channel, "", "player", puuid)
    {:reply, nil, state}
  end
end
