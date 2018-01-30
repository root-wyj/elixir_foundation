defmodule FibClient do
    require Logger

    # def receiver(list) do
    #     list |> Enum.map(fn n ->
    #         receive do
    #             {:ready, from} ->
    #                 IO.puts "get ready msg. so send #{n} to server #{inspect from}"
    #                 spawn_link(FibClient, :send_and_receive, [from, n, self()])
    #         end
    #     end
    #     )
        
    # end

    def start_caculate(list) do

        # pid_result = spawn_link(FibClient, :receive_result, [self()])

        list |> Enum.map(fn n ->
            receive do
                {:ready, server} ->
                    IO.puts "get ready msg. so send #{n} to server #{inspect server}"
                    spawn_link(FibClient, :send_and_receive, [server, n, self()])
                    receive do
                        {:answer, ^n, result, ^server} -> 
                            IO.puts "get result from server fn(#{n}): #{result}" 
                    end
            end
        end
        )
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

    # spawn(FibClient, :receiver, [[2, 3, 40, 5]])

end