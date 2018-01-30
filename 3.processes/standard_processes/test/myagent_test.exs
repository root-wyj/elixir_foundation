defmodule MyagentTest do
  use ExUnit.Case, async: true
  # async: true 表示异步，可以与有相同标注的Test同步执行
  doctest Myagent

  #在该test中， 运行在所有test之前，并且将返回值放入到test context中
  #test context 是一个map，所以这里返回的返回值会直接合并到其中。
  setup do
    #这种方式启动的进程，会在test结束的时候自动终止
    # supervise 监督
    {:ok, bucket} = start_supervised(Myagent)
    %{bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    
    assert Myagent.get(bucket, "milk") == nil

    Myagent.put(bucket, "milk", 3)
    assert Myagent.get(bucket, "milk") == 3
  end


  test "count by self" do
    {:ok, pid} = CounterSelf.start(0)
    assert {:ok, 0} = CounterSelf.get(pid)
    CounterSelf.increment(pid)
    CounterSelf.increment(pid)
    assert {:ok, 2} = CounterSelf.get(pid)
    CounterSelf.decrement(pid)
    assert {:ok, 1} = CounterSelf.get(pid)
  end

  test "count by agent" do
    {:ok, pid} = CounterAgent.start(0)
    assert {:ok, 0} = CounterAgent.get(pid)
    CounterAgent.increment(pid)
    CounterAgent.increment(pid)
    assert {:ok, 2} = CounterAgent.get(pid)
    CounterAgent.decrement(pid)
    assert {:ok, 1} = CounterAgent.get(pid)
  end

  
end
