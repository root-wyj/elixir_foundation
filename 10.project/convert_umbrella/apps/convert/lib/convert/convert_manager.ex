defmodule ConvertManager do
  use ExActor.GenServer, export: __MODULE__

  require Logger


  # defstart start_link, do: initial_state(arg)

  # defcall foo, do: set_and_reply(new_state, response)
  # defcast bar, do: new_state(new_state)

  # defhandleinfo :stop, do: stop(normal)
  # defhandleinfo _, do: noreply

  defstart start_link do 
    Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
    #{inspect ConvertManager}"

      initial_state(%{})
  end

  defcast start_work(%{"id" => id, "type" => "pdf"} = params), state: state do
    start_work_(params, :pdf, 5)
    noreply
  end

  defcast start_work(%{"id" => id, "type" => "doc"} = params), state: state do
    start_work_(params, :pdf, 5)
    noreply
  end

  defcast start_work(%{"id" => id, "type" => "docx"} = params), state: state do
    start_work_(params, :pdf, 5)
    noreply
  end

  defp start_work_(%{"id" => id} = params, key, max_count) do
    Logger.debug "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
    #{inspect self}"
    #首先判断这个文件是不是之前已经转过了
    case StatusManager.isConverted(params) do
      {:ok, _} ->
        Logger.debug "#{id} had converted"
        ConvertQueue.pdf_check()
      {:error, _} ->
        {:ok, exist} = ConvertWorkerContainer.contains_worker(id, key)
        if exist do
          Logger.debug "#{id} converting ..."
          ConvertQueue.pdf_check()
        else
          {:ok, size} = ConvertWorkerContainer.size_worker(key)
          if size >= max_count do
            Logger.debug "#{inspect key} workers are all in work, so in queue ..."
            ConvertQueue.pdf_in(params)
          else
            {:ok, pid} = ConvertWorker.start(params)
            Process.unlink pid
            Logger.debug "#{inspect key} start worker, #{inspect pid}"
            ConvertWorkerContainer.add_worker(id, pid, key)
          end
        end
    end
  end

  defcast decrement(%{id: id, type: "pdf"} = params), state: state do
    decrement_(id, :pdf)
    noreply
  end

  defcast decrement(%{id: id, type: "doc"} = params), state: state do
    decrement_(id, :pdf)
    noreply
  end

  defcast decrement(%{id: id, type: "docx"} = params), state: state do
    decrement_(id, :pdf)
    noreply
  end

  defp decrement_(id, key) do
    ConvertWorkerContainer.remove_worker(id, key)
    Logger.debug("deleted workers:#{inspect(id)}")
    ConvertQueue.pdf_check()
  end


  def handle_info msg, state do
    Logger.debug "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
    #{inspect msg}"
    {:noreply, state}
  end
end
