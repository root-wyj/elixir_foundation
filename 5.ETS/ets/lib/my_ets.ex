defmodule MyEts do
    use GenServer

    # :ets.new(:my_bucket, [:named_table])
    # :ets.insert(:my_bucket, {"foo", self()})
    # :ets.lookup(:my_bucket, "foo")


    def start_link(opts) do
        # 1. Pass the name to GenServer's init
        server = Keyword.fetch(opts, :name);
        GenServer.start_link(_MODULE_, server, opts);
    end

    def lookup(server, name) do
        # 2. Lookup is now done directly in ETS, without accessing the server
        case :ets.lookup(server, name) do
            [{^name, pid}] -> {:ok, pid}
            [] -> :error
        end
    end

    def create(server, name) do
        GenServer.cast(server, {:create, name})
    end


    #server callback
    def init(table) do
        # 3. We have replaced the names map by the ETS table
        names = :ets.new(table, [:named_table, read_concurrency: true])
        refs = %{}
        {:ok, {names, refs}}
    end

    # 4. The previous handle_call callback for lookup was removed

    def handle_cast({:create, name}, {names, refs}) do
        # 5. Read and write to the ETS table instead of the map
        case lookup(names, name) do
            {:ok, pid} -> 
                {:noreply, {names, refs}}
            :error ->
                {:ok, pid} = start_link()
                ref = Process.monitor(pid)
                :ets.insert(names, {name, pid})
                {:noreply, {names, refs}}
        end

    end

    def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
        # 6. Delete from the ETS table instead of the map
        {name, refs} = Map.pop(refs, ref)
        {:noreply, {names, refs}}
    end

    def handle_info(_msg, state) do
        {:noreply, state}
    end








end