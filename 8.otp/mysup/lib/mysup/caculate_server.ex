defmodule Mysup.CaculateServer do
    use GenServer
    require Logger


    @vsn "0"

    def start_link() do
        GenServer.start_link(__MODULE__, 100, name: __MODULE__)

    end

    def increment(delta) do
        GenServer.call(__MODULE__, {:increment, delta})
    end

    def decrement do
        GenServer.call(__MODULE__, :decrement)
    end

    #callback
    def init(init_number) do
        Logger.debug "#{inspect __MODULE__} start"
        case Mysup.Stash.get(__MODULE__) do
            {:ok, value} ->
                Logger.debug "get value from stash. value:#{inspect value}"
                {:ok, value}
            {:error, _} ->
                Logger.debug "get value failed from stash."
                {:ok, init_number}
        end
    end

    def handle_call({:increment, delta}, _from, init_number) do
        {:reply, {:ok, init_number+delta}, init_number+delta}
    end

    def handle_call(:decrement, _from, init_number) do
        {:reply, {:ok, init_number-1}, init_number-1}
    end

    def terminate(reason, init_number) do
        Logger.info "#{inspect __MODULE__} terminal. reason:#{inspect reason} finally number is #{init_number}"
        Mysup.Stash.save(__MODULE__, init_number)
    end
end