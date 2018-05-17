defmodule DetsChild do
    require Logger
    use GenServer
    
    @dets_dir Setting.get(:db_dir)
    @interval 10*60*1000

    def start_link(process_name) when is_atom(process_name) do
        GenServer.start_link(DetsChild, {:ok, process_name}, [name: process_name])
    end

    # Returning {:ok, state} will cause start_link/3 to return {:ok, pid} and the process to enter its loop.
    def init({:ok, process_name}) when is_atom(process_name) do
        dets_name = to_charlist(@dets_dir) ++ '/' ++ to_charlist(process_name) ++ '.dets'
        :dets.open_file(process_name, [{:auto_save, @interval}, {:file, dets_name}, {:type, :set}])
        {:ok, %{dets_name: process_name}}
    end


    def terminate(reason, state) do
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        dets terminate #{inspect state.dets_name}"
        :dets.close(state.dets_name)
        :ok
    end

    #------------ call and cast start ---------
    def save(process_name, id, map) do
        GenServer.cast(process_name, {:save, id, map})
    end

    def handle_cast({:save, id, map}, state) do
        :dets.insert(state.dets_name, {id, map})
        {:noreply, state}
    end

    def del(process_name, id) do
        GenServer.cast(process_name, {:del, id})
    end

    def handle_cast({:del, id}, state) do
        :dets.delete(state.dets_name, id)
        {:noreply, state}
    end

    def handle_info(msg, state) do
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect state.dets_name} get unhandled msg #{inspect msg}"
        {:noreply, state}
    end

    #--------- call and cast end ------------

end