defmodule FridgeServer do
    use GenServer

    #client
    def start_link(opts \\ []) do
        GenServer.start_link(__MODULE__, :ok, opts)
    end

    def store(pid, item) do
        GenServer.call(pid, {:store, item})
    end

    def take(pid, item) do
        GenServer.call(pid, {:take, item})
    end

    #callback
    def init(:ok) do
        {:ok, []}
    end

    def handle_call({:store, food}, _from, state) do
        {:reply, :ok, [food | state]}
    end

    def handle_call({:take, food}, _from, state) do
        case Enum.member?(state, food) do
            true ->
                {:reply, food, List.delete(state, food)}
            false ->
                {:reply, :not_found, state}
        end
    end

end