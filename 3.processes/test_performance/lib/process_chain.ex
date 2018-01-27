defmodule ProcessesChain do

    def count(target) do
        receive do
            n ->
            send(target, n+1)
        end
    end

    def create_processes(n) do
        last = Enum.reduce(1..n, self(),
            fn (_,send_to) ->
                spawn(ProcessesChain, :count, [send_to])
            end)

        send last, 0

        receive do
            last_number when is_integer(last_number) ->
                "result is #{last_number}"
        end
    end

    #经过测试，在本机器上 跑10W个进程，耗时 266ms，说明Elixir的进程优化 相当不错
    def run(n) do
        IO.puts "#{inspect :timer.tc(ProcessesChain, :create_processes, [n])}"
    end


    #将上一次操作的返回值 作为这次操作的acc
    def test_enum_reduce() do
        Enum.reduce(1..5, 2, fn x,acc ->
            IO.puts "#{x}, acc:#{acc}"
            x*acc
            end)
    end
end