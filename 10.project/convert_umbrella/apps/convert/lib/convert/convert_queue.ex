defmodule ConvertQueue do
    use ExActor.GenServer, export: __MODULE__
    require Logger

    defstart start_link do

        :ets.new :pdf_queue, [:named_table]
        # :ets.new :doc_queue, [:named_table, read_concurrency: true]
        initial_state(%{})
    end

    @compile {:parse_transform, :ms_transform}
    defcast pdf_in(%{"id" => id, "type" => "pdf"} = args), state: state do
        Logger.debug "GenServer server, args:#{inspect args}"
        :ets.insert(:pdf_queue, {id, args})

        count = queue_size_(:pdf_queue)
        Logger.debug "queue count :#{count}"
        noreply
    end

    defcall pdf_out(), state: state do

        case :ets.first :pdf_queue do
            :'$end_of_table' ->
                Logger.debug "queue is empty"
                reply({:error, "is empty"})
            id ->
                [{_id, args} | _tail] = :ets.take :pdf_queue, id
                Logger.debug "pop queue args:#{inspect args}"
                reply({:ok, args})
        end
    end

    defcast pdf_check(), state: state do
        case :ets.first :pdf_queue do
            :'$end_of_table' ->
                Logger.debug "queue is empty"
                noreply
            id ->
                [{_id, args} | _tail] = :ets.take :pdf_queue, id
                ConvertManager.start_work(args)
                Logger.debug "pop queue args:#{inspect args}"
                noreply
        end
    end

    defcall pdf_queue_size(), state: state do
        count = queue_size_(:pdf_queue)
        Logger.debug "queue count :#{count}"
        reply({:ok, count})
    end

    defp queue_size_(type) do
        ms = :ets.fun2ms(fn {id, args} -> true end)
        count = :ets.select_count(type, ms)
    end

end