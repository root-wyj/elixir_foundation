defmodule ConvertPageManager do
    use ExActor.GenServer, export: __MODULE__

    require Logger

    defstart start_link do
        Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect ConvertPageManager}"
    
        initial_state(%{})
    end

    defcast start_worker(%{"type" => "pdf", "page" => page} = params), state: state do
        start_worker_(params, 10, state)
        noreply
    end

    defcast decrement(%{id: id, page: page} = params), state: state do
        Logger.debug "decrement a worker. params:#{inspect params}"
        case ConvertWorkerPageContainer.remove(id, page) do
            {:ok, []} ->
                %{}
            {:ok, list} ->
                Logger.debug "notify all the request. list:#{inspect list}"
                Enum.map(list, fn pid -> notify_to_reward(pid) end)

        end
        ConvertPageQueue.check()
        noreply
    end

    defp start_worker_(%{"id" => id, "page" => page, "from" => from} = params, max, state) do
        filepath = Path.join(Application.get_env(:convert, :file_download_dir), params["id"]<>".pdf")
        if File.exists?(filepath) do
            case ConvertWorkerPageContainer.contains(params) do
                {:ok, true} ->
                    Logger.debug "id:#{id}, page:#{page} converting"
                    case ConvertWorkerPageContainer.merge(params) do
                        {:ok, true} ->
                            Logger.debug "already in, so merge and checkqueue"
                            ConvertPageQueue.check()
                        {:ok, false} ->
                            Logger.debug "not in worker(show that worker finished just), and then put in queue"
                            ConvertPageQueue.push(params)
                    end
                {:ok, false} ->
                    Logger.debug "id:#{id}, page:#{page} not converting"
                    work_size = ConvertWorkerPageContainer.worker_size()
                    if (work_size < max) do
                        Logger.debug "work_size:#{work_size}. max:#{max}, so start new work"
                        {:ok, pid} = ConvertPageWorker.start(params)
                        Process.unlink pid
                        case ConvertWorkerPageContainer.add_worker(params, pid) do
                            {:ok, true} ->
                                %{}
                            {:ok, false} ->
                                Logger.info "add worker to container failed, because has one same worker is working .but started... . so we check the queue for another"
                                ConvertPageQueue.check()
                        end
                    else
                        Logger.debug "work_size:#{work_size}. max:#{max}, so in queue"
                        ConvertPageQueue.push(params)
                    end
            end
        else
            #TODO send error msg
            Logger.error "no pdf file, so return error"
            send from, {:error, "not found file"}
        end
    end

    defp notify_to_reward(pid) do
        send pid, {:ok, "success"}
    end
end