defmodule DailydripSupervisorTest do
  use ExUnit.Case

  test "genserver 1" do
    {:ok, pid} = GenServer.start_link(FridgeServer, :ok, [])
    assert :ok == GenServer.call(pid, {:store, :bacon})
    assert :not_found == GenServer.call(pid, {:take, :potato})
    assert :bacon = GenServer.call(pid, {:take, :bacon})
  end
end
