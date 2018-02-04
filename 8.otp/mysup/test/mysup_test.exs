defmodule MysupTest do
  use ExUnit.Case
  doctest Mysup

  test "greets the world" do
    assert Mysup.hello() == :world
  end
end
