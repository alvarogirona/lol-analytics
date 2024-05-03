defmodule Scrapper.Queue.MatchQueue do
  use GenServer

  @spec start_link(any()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, {}, name: __MODULE__)
  end

  @spec init({}) :: {:ok, %{channel: AMQP.Channel.t(), connection: AMQP.Connection.t()}}
  def init({}) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, "match", durable: true)
    {:ok, %{:channel => channel, :connection => connection}}
  end

  @spec queue_match(String.t()) :: any()
  def queue_match(match_id) do
    LolAnalytics.Match.MatchRepo.get_match(match_id)
    |> case do
      nil -> GenServer.call(__MODULE__, {:queue_match, match_id})
      match -> :already_processed
    end
  end

  def handle_call({:queue_match, match_id}, _from, %{:channel => channel} = state) do
    AMQP.Basic.publish(channel, "", "match", match_id)
    {:reply, nil, state}
  end

  def terminate(_reason, {_, connection}) do
    AMQP.Connection.close(connection)
  end
end
