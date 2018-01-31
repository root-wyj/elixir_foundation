defmodule TaskApplication do
    use Application

    def start(_type, _args) do
        children = [
            {Task.Supervisor, name: MyTask.Task.Supervisor},
            {Task, fn -> EchoServerNormal.accept(4040) end}
        ]
        opts = [strategy: :one_for_one, name: MyTask.Supervisor]
        Supervisor.start_link(children, opts)
    end
end