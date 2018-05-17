defmodule DetsManager do
    require Logger
    use ExActor.GenServer, export: __MODULE__

    @prefix "dets_child_"
    @dets_counts 10000

    defstart start_link() do
        import Supervisor.Spec

        state = %{}

        {_, children} = 
        Enum.map_reduce(0..(@dets_counts-1), [], fn item, children ->
            process_name = get_dets_process_name(item)

            {item, [Supervisor.child_spec({DetsChild, process_name}, id: process_name) | children]}
        end)
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        loading dets files, please waiting ..."
        opts = [strategy: :one_for_one, name: DetsManager.Supervisor]
        result = Supervisor.start_link(children, opts)
        Logger.info "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        loaded dets files success"

        initial_state(state)
    end

    
    def save(id, meta) do
        DetsChild.save(get_dets_process_name(id), id, meta)
    end

    def del(id) do
        DetsChild.del(get_dets_process_name(id), id)
    end

    def find(id) do
        case :dets.lookup(get_dets_process_name(id), id) do
            [] ->
                nil
            [{_, meta} | _] ->
                meta
        end
    end


    # ----------- private ----------------

    defp get_dets_process_name(id) when is_bitstring(id) do
        get_dets_process_name(String.to_integer(id))
    end
    
    defp get_dets_process_name(id) when is_integer(id) do
        num = rem(id, @dets_counts)
        String.to_atom(@prefix <> to_string(num))
    end


end