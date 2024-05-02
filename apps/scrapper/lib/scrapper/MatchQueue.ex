defmodule Scrapper.MatchQueue do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, {}, name: __MODULE__)
  end

  def init({}) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    {:ok, {channel, connection}}
  end

  @spec queue_match(String.t()) :: any()
  def queue_match(match_id) do
    GenServer.call(__MODULE__, {:queue_match, match_id})
  end

  def handle_call({:queue_match, match_id}, from, {channel, _} = state) do
    AMQP.Basic.publish(channel, "", "match", match_id)
    {:reply, nil, state}
  end

  def terminate(_reason, {_, connection}) do
    AMQP.Connection.close(connection)
  end
end
