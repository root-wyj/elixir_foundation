defmodule MySupervision do
    use Supervisor

    def start_link(opts) do
        Supervisor.start_link(__MODULE__, :ok, opts)
    end

    #callback
    def init(:ok) do
        # %{id: Stack, restart: :permanent, shutdown: 5000, start: {Stack, :start_link, [[]]}, type: :worker}
        # 每一个实现了 GenServer都会有一个方法可以调用，'child_spec(args)' args是这个GenServer的start_link方法的参数列表。
        # 返回值，就是上面的格式，也是下面这里定义children的格式
        children = [
            %{
                id: Stack,
                start: {Stack, :start_link, [[]]}
            }
        ]

        Supervisor.init(children, strategy: :one_for_one)
    end

    #这句话 会在编译时 输出。。。（mix compile）
    IO.puts "this is my_supervision"

    # 会报编译时 错误
    # MySupervision.start_link([])

end
