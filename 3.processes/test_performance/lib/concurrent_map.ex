defmodule Parallel do
    #对collection中的每一个元素 开启一个新的进程执行fun方法，并在最后，将结果通知到原来进程
    def parallel_map(collection, fun) do
        me = self()

        collection
            #这里返回了新启动的进程列表
            |> Enum.map(fn x ->
                spawn_link(fn -> send me, {self(),fun.(x)} end)
                end)
            |> Enum.map(fn pid -> receive do
                        {^pid, result} ->
                            result
                        end
                    end)
    end

    def test_fun n do
        n*n
    end

    def run do
        IO.puts "#{inspect Parallel.parallel_map 1..10, &Parallel.test_fun/1}"
    end
end