defmodule CatlixirTest do
  use ExUnit.Case
  doctest Catlixir

  test "greets the world" do
    assert Catlixir.hello() == :world
  end
end
