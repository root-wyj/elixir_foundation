defmodule CounterAgent do
    use Agent

    def start(init_value) do
        Agent.start(fn -> init_value end)
    end

    def get(pid) do
        Agent.get(pid, fn x -> {:ok, x} end)
    end

    def increment(pid) do
        Agent.update(pid, fn x -> x+1 end)
    end

    def decrement(pid) do
        Agent.update(pid, fn x -> x-1 end)
    end
end