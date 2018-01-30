defmodule DailydripSupervisor.Application do
    use Application

    def start(_type, _args) do
      import Supervisor.Spec, warn: false
      children = [
        # %{
          # id: FridgeServer,
          # start: {FridgeServer, :start_link, [[:name, Fridge]]}
        # }
        worker(FridgeServer, [[name: Fridge]])
      ]
      opts = [strategy: :one_for_one, name: DailydripSupervisor.Supervisor]
      IO.puts "application start"
      Supervisor.start_link(children, opts)
    end

end
