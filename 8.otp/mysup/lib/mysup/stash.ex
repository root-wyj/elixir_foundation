defmodule Mysup.Stash do
#该模块用来保存其他Process的state的。用于在其他Process死掉的时候
#   能够恢复原来的数据。 （这个Process最好有一个名字，这里用名字作为key）
    use GenServer
    require Logger

    def start_link() do
        GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
    end

    def save(key, value) do
        GenServer.cast(__MODULE__, {:save, key, value})
    end

    def get(key) do
        GenServer.call(__MODULE__, {:get, key})
    end

    #callback
    def handle_cast({:save, key, value}, state) do
        Logger.debug "stash save key:#{inspect key}, value:#{inspect value}"
        {:noreply, Map.put(state, key, value)}
    end

    def handle_call({:get, key}, _from, state) do
        case Map.get(state, key) do
            nil ->
                {:reply, {:error, :notfound}, state}
            value ->
                Logger.debug "stash get key:#{inspect key}, value:#{inspect value}"
                {:reply, {:ok, value}, state}
        end
    end
end