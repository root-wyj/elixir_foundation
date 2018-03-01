defmodule Mysup.SubSupervisor do
    use Supervisor

    def start_link() do
        Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    end

    def init(:ok) do
        child_process = [
            worker(Mysup.CaculateServer, [])
        ]
        Supervisor.init(child_process, strategy: :one_for_one)
    end
end