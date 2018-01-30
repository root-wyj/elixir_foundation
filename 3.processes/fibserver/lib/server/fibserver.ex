defmodule FibServer do
    require Logger

    def scheduling() do
        receive do
            {:fib, n, from} ->
                IO.puts "server get msg from #{inspect from}, fib(#{n})"
                result = caculate n
                send from, {:answer, n, result, self()}
                send from, {:ready, self()}
        end
        
    end

    def caculate(n) do
        caculate_(n)
    end

    defp caculate_(1) do
        1
    end

    defp caculate_(2) do
        1
    end

    defp caculate_(n) do
        caculate_(n-1) + caculate_(n-2)
    end

    # spawn_link(FibServer, :scheduling, [])
end
