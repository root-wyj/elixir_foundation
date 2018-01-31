defmodule CounterAgent do
    use Agent

    def start do
        Agent.start(fn -> 0 end)
    end

    def increment(pid) do
        Agent.update(pid, fn n -> n+1 end)
    end

    def decrement(pid) do
        Agent.update(pid, fn n -> n-1 end)
    end

    def get(pid) do
        Agent.get(pid, fn n -> n end)
    end
end
