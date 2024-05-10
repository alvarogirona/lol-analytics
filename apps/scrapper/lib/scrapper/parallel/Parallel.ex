defmodule Scrapper.Parallel do
  def peach(enum, fun, concurrency \\ 10, timeout \\ :infinity) do
    Task.async_stream(enum, &fun.(&1), max_concurrency: concurrency, timeout: timeout)
    |> Stream.each(fn {:ok, val} -> val end)
    |> Enum.to_list()
  end
end
