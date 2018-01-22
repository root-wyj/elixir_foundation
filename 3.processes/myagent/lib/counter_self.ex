defmodule CounterSelf do
    def start(init_value) do
        {:ok, spawn(CounterSelf, :loop, [init_value])}
    end

    def loop(value) do
        receive do
            :increment -> loop(value+1)
            :decrement -> loop(value-1)
            {from, ref, :get_value} ->
                send(from, {:ok, ref, value})
                loop(value)
            _ -> loop(value)
        end
    end

    def get(pid) do
        ref = make_ref()
        send(pid, {self(), ref, :get_value})

        receive do
            {:ok, ^ref, value} -> {:ok, value}
        end
    end

    def increment(pid) do
        send(pid, :increment)
        :ok
    end

    def decrement(pid) do
        send(pid, :decrement)
        :ok
    end

end