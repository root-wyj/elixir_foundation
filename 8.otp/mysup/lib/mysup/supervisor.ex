defmodule Mysup.Supervisor do
    use Supervisor

    def start_link() do
        result = {:ok, sup} = Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
        #上面的方法调用之后 就会回调init，之后再返回这里继续执行

        # 设置被监视的child
        # Supervisor.start_child(__MODULE__, worker(Mysup.Stash, []))
        # Supervisor.start_child(__MODULE__, worker(Mysup.SubSupervisor, []))

        result
    end

    #注意Supervisor的回调 init/1 必有参数
    def init(:ok) do
        children = [
            worker(Mysup.Stash, []),
            worker(Mysup.SubSupervisor, [])
        ]
        Supervisor.init(children, strategy: :one_for_one)
    end
end