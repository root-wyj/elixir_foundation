defmodule MytaskTest do
  use ExUnit.Case
  doctest Mytask

  test "greets the world" do
    assert Mytask.hello() == :world
  end
end
