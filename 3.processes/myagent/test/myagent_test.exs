defmodule MyagentTest do
  use ExUnit.Case

  test "counter_agent" do
    {:ok, pid} = CounterAgent.start()
    CounterAgent.increment(pid)
    IO.puts "inc #{CounterAgent.get(pid)}"
    CounterAgent.increment(pid)
    IO.puts "inc #{CounterAgent.get(pid)}"
    CounterAgent.decrement(pid)
    IO.puts "dec #{CounterAgent.get(pid)}"
  end

  test "counter_process" do
    {:ok, pid} = CounterProcess.start()
    CounterProcess.increment(pid)
    IO.puts "inc #{CounterProcess.get(pid)}"
    CounterProcess.increment(pid)
    IO.puts "inc #{CounterProcess.get(pid)}"
    CounterProcess.decrement(pid)
    IO.puts "dec #{CounterProcess.get(pid)}"
  end
end
