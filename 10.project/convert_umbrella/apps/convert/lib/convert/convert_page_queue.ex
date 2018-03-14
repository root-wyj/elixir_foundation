defmodule ConvertPageQueue do
    use ExActor.GenServer, export: __MODULE__
    require Logger

    defstart start_link() do
        :ets.new(:pdf_page_queue, [:named_table])
        initial_state(%{})
    end

    defcast push(%{"id" => id, "page" => page} = params), state: state do
        key = id<>"_"<>page
        :ets.insert(:pdf_page_queue, {key, params})
        count = queue_size_(:pdf_page_queue)
        Logger.debug "pdf_page_queue size:#{count}"
        noreply
    end

    defcast check(), state: state do
        case :ets.first(:pdf_page_queue) do
            :'$end_of_table' ->
                Logger.info "pdf_page_queue is empty"
                noreply
            key ->
                [{_key, params} | _tail] = :ets.take :pdf_page_queue, key
                ConvertPageManager.start_worker(params)
                Logger.debug "pdf_page_queue pop #{inspect params}"
        end

    end

    @compile {:parse_transform, :ms_transform}
    defp queue_size_(name) do
        ms = :ets.fun2ms(fn {id, args} -> true end)
        count = :ets.select_count(name, ms)
    end

end