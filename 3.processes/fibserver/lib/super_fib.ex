defmodule Fib do
    require Logger
    # Elixir程序设计中 给出的客户端调服务器 来计算fib数据的 例子
    # 该例 实现了 
    # 1. 保存数据
    # 2. 启动服务的个数 完全可以自定义
    # 总而言之，就是 感觉很吊

    defmodule Server do
        def fib(pid_client) do
            send pid_client, {:ready, self()}
            receive do
                {:fib, n, pid_client} ->
                    send pid_client, {:answer, n, caculate_(n), self()}
                    fib(pid_client)
                {:shutdown} ->
                    Logger.debug "server #{inspect self()} exit"
                    exit(:normal)
            end
        end

        defp caculate_(1), do: 1
    
        defp caculate_(2), do: 1
    
        defp caculate_(n) do
            caculate_(n-1) + caculate_(n-2)
        end
    end

    defmodule Client do
        # 这里启动了n个server进程，他们会向客户端进程发送准备好了的消息
        # 这时候 客户端就向服务器发送请求，

        # 在这个模型中，客户端只是接受服务器给的消息，并作出相应的动作。而服务器
        #   仅仅是计算
        def run(process_count, fib_list) do
            (1..process_count)
                |> Enum.map(fn _n -> spawn(Fib.Server, :fib, [self()]) end)
                |> schedule_process_(fib_list, [])
        end

        defp schedule_process_(processes, fib_list, result) do
            receive do
                # 这里只是 处理 `我该发消息了` 的操作
                {:ready, pid_server} when length(fib_list) > 0 ->
                    [head | tail] = fib_list
                    Logger.debug "server is ready, so send #{head} to server"
                    send pid_server, {:fib, head, self()}
                    schedule_process_(processes, tail, result)
                # 这时候 已经没有数据需要往服务器发了
                # 所以，把服务器都关掉就行了
                {:ready, pid_server} ->
                    Logger.debug "all client data have been send to server, and server #{inspect pid_server} is ready"
                    send pid_server, {:shutdown}
                    processes = List.delete(processes, pid_server)

                    # 当到达最后一刻的时候，给结果排个序. 这里也是该方法的出口
                    if (length(processes) == 0) do
                        Logger.debug "is time to return"
                        Logger.debug "before sort:#{inspect result}"
                        result = Enum.sort(result, fn {n1, _},{n2, _}  -> n1 <= n2 end)
                        Logger.debug "after sort:#{inspect result}"
                    else
                        schedule_process_(processes, fib_list, result)
                    end
                    
                {:answer, n, fib_n, pid_server} ->
                    Logger.debug "get result from server \{#{n}, #{fib_n}\}, result:#{inspect result}"
                    schedule_process_(processes, fib_list, [{n, fib_n} | result])
            end
        end
    end


    def test do
        Client.run(5, [2, 5, 10, 15, 37])
    end

    # 写在最后 我认为这里例子充分体现了 `函数式编程` 和 `消息式编程` 的精髓
end