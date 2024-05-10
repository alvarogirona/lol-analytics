defmodule LoLAPITest do
  use ExUnit.Case
  doctest LoLAPI

  test "greets the world" do
    assert LoLAPI.hello() == :world
  end
end
