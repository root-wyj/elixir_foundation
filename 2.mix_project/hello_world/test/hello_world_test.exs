defmodule HelloWorldTest do
  use ExUnit.Case
  doctest HelloWorld

  test "greets the world" do
    assert HelloWorld.hello() == :world
  end

  test "division by zero" do
    {:error, err} = HelloWorld.div(4, 0)
    assert err == "attempt at division by zero"
  end

  test "division" do
    {:ok, result} = HelloWorld.div(4, 2)
    assert result == 2.0
  end
end
