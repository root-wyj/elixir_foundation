defmodule ConvertWorkerContainer do
    use ExActor.GenServer, export: __MODULE__
    require Logger

    defstart start_link do

        :ets.new :pdf_worker, [:named_table]
        # :ets.new :word_worker, [:named_table, read_concurrency: true]
        initial_state(%{})
    end

    #return {:ok, boolean()}
    defcall add_worker(id, pid, :pdf), state: state do
        reply {:ok, :ets.insert(:pdf_worker, {id, pid})}
    end

    defcall add_worker(id, pid, :word), state: state do
        reply {:ok}
    end

    #return {:ok, boolean()}
    defcall remove_worker(id, :pdf), state: state do
        reply {:ok, :ets.delete(:pdf_worker, id)}
    end

    defcall remove_worker(id, :word), state: state do
        reply {:ok}
    end

    #return {:ok, size}
    defcall size_worker(:pdf), state: state do
        reply {:ok, table_size(:pdf_worker)}
    end

    defcall size_worker(:word), state: state do
        reply {:ok, 0}
    end

    #return {:ok, boolean}
    defcall contains_worker(id, :pdf), state: state do
        pids = :ets.lookup(:pdf_worker, id)
        pid = List.first(pids);        
        reply {:ok, pid}
    end

    defcall contains_worker(id, :word), state: state do
        reply {:ok}
    end

    @compile {:parse_transform, :ms_transform}
    defp table_size(table_name) do
        ms = :ets.fun2ms(fn {id, pid} -> true end)
        :ets.select_count table_name, ms
    end

end