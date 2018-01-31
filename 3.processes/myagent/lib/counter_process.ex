defmodule CounterProcess do
    
    def start do
        {:ok, spawn(CounterProcess, :loop, [0])}
    end

    def loop (i) do
        receive do
            :increment ->
                loop(i+1)
            :decrement ->
                loop(i-1)
            {:get, from} ->
                send from, {:ok, i}
                loop(i)
        end
    end

    def get(pid) do
        send pid, {:get, self()}
        receive do
            {:ok, count} ->
                count
        end
    end

    def increment(pid) do
        send pid, :increment
    end

    def decrement(pid) do
        send pid, :decrement
    end

end