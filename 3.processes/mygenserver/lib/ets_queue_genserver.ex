defmodule EtsQueue do
    use GenServer
    require Logger


    def start_link(opts) do
        Logger.debug "wyj client init GenServer"
        GenServer.start_link(__MODULE__, :ok, opts)
    end

    # def in(server, %{"id" => id, "type" => "pdf"} = args) do
        # GenServer.cast(server, {:in, args})
    # end

    #GenServer callbacks
    def init(:ok) do
        Logger.debug "wyj server init GenServer"
        ets_name = :ets.new(:pdf_queue, [:named_table, read_concurrency: true])
        %{pdf_queue: ets_name}
    end

    def handle_cast({:in, %{"id" => id, "type" => "pdf"} = args}, _from, state) do
        Logger.debug("server get msg:#{inspect args}")
        :ets.insert :pdf_queue, {id, args}
        {:noreply, state}
    end

    def handle_call({:out}, _from, state) do
        case :ets.last :pdf_queue do
            :"$end_of_table" ->
                {:reply, {:error, "is empty"}, state}
            id ->
                args = :ets.lookup :pdf_queue, id
                :ets.delete :pdf_queue, id
                {:reply, {:ok, args}, state}
        end
    end

    def handle_cast({:out_recursive}, _from, state) do
        case :ets.last :pdf_queue do
            :"$end_of_table" ->
                IO.puts("is empty")
                {:error, "is empty"}
            id ->
                args = :ets.lookup :pdf_queue, id
                :ets.delete :pdf_queue, id
                IO.puts "#{inspect args}"
                GenServer.cast(self(), {:out_recursive})
        end
        {:noreply, state}
    end

end