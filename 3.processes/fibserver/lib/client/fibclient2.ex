defmodule FibClient2 do
    require Logger


    def start_caculate() do

        receive do
            {:ready, server} ->
                [2, 5, 8, 10, 15]
                    |> Enum.map(fn n -> spawn_link(FibClient2, :send_and_receive, [server, n, self()]) end)
                    |> schedule()
        end
    end

    def schedule([_head|tail]) do
        receive do
            {:answer, n, result, pid} ->
                if (length(tail) == 0) do
                    send(pid, {:shutdown})
                else
                    IO.puts "get result from server fn(#{n}): #{result}"
                    schedule(tail) 
                end
        end
    end

    # def receive_result(pid_parent) do
    #     receive do
    #          {:answer, n, result, pid_server} -> 
    #             IO.puts "get result from server fn(#{n}): #{result}"
    #             send pid_parent, 
    #     end
    
    # end

    def send_and_receive(pid_server, n, pid_parent) do
        IO.puts "start a process #{inspect self()}, and send #{n} to server"
        send pid_server, {:fib, n, pid_parent}
    end
end