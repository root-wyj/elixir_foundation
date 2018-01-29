defmodule MygenserverTest do
  use ExUnit.Case
  require Logger
  require GenServer

  setup do
    {:ok, pid} = start_supervised(MyGenServer)
    {:ok, queue_id} = start_supervised(EtsQueue)
    %{pid: pid, queue: queue_id}
  end

  test "hello", %{pid: pid} do
    Logger.debug("hello test start")
    assert MyGenServer.lookup(pid, "shopping") == :error
    MyGenServer.create(pid, "shopping")

    assert {:ok, bucket} = MyGenServer.lookup(pid, "shopping")
    IO.puts("#{inspect bucket}")
  end

  test "ets queue", %{queue: queue_id} do
    Logger.debug("ets queue start")
    list = [%{"id" => "1", "type" => "pdf"},
    %{"id" => "2", "type" => "pdf"},
    %{"id" => "3", "type" => "pdf"},
    %{"id" => "4", "type" => "pdf"},
    %{"id" => "5", "type" => "pdf"},
    %{"id" => "6", "type" => "pdf"},
    ]
    # EtsQueue.in(queue_id, %{"id" => "2", "type" => "pdf"})
    Logger.debug "client send msg"
    GenServer.cast(queue_id, {:in, %{"id" => "2", "type" => "pdf"}})
  end

end
