defmodule Stack do
    use GenServer

    def start_link(opt) do
        GenServer.start_link(__MODULE__, [:hello], name: __MODULE__)
    end

    def test do
        GenServer.call(Stack, :pop)
    end

    #callback
    def init(state) do
        {:ok, state}
    end

    def handle_call(:pop, _from, [head | tail]) do
        {:reply, head, tail}
    end

    def handle_cast({:push, h}, _from, tail) do
        {:noreply, [h | tail]}
    end

    IO.puts "this is stack"
end