defmodule LogManager do
    use ExActor.GenServer, export: __MODULE__
    require Logger

    defstart start_link do
        Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect ConvertManager}"
        :dets.open_file(__MODULE__, {:file, 'log_manager.dets'})
        Logger.debug("dets file:#{inspect :dets.info(__MODULE__)}")
        initial_state(%{})
    end

    defcast log({:doc_base, %{id: id, file_size: file_size, page_count: page_count} = msg}), state: state do
        Logger.debug "#{inspect __MODULE__} msg:#{inspect msg}"
        case :dets.lookup(__MODULE__, id) do
            [] -> :dets.insert(__MODULE__, {id, msg})
            [{^id, head} | tail] ->
                head = head |> Map.put(:file_size, file_size) |> Map.put(:page_count, page_count)
                :dets.insert(__MODULE__, {id, head})
        end
        noreply
    end

    defcast log({:doc_font, %{id: id, font_time: font_time} = msg}), state: state do
        Logger.debug "#{inspect __MODULE__} msg:#{inspect msg}"
        case :dets.lookup(__MODULE__, id) do
            [] -> :dets.insert(__MODULE__, {id, msg})
            [{^id, head} | tail] ->
                head = head |> Map.put(:font_time, font_time)
                :dets.insert(__MODULE__, {id, head})
        end
        noreply
    end

    defcast log({:doc_page, %{id: id, pages: pages} = msg}), state: state do
        Logger.debug "#{inspect __MODULE__} msg:#{inspect msg}"
        case :dets.lookup(__MODULE__, id) do
            [] -> :dets.insert(__MODULE__, {id, msg})
            [{^id, head} | tail] ->
                if (Map.get(head, :pages) == nil) do
                    head = head |> Map.put(:pages, pages)
                    :dets.insert(__MODULE__, {id, head})
                else
                    pages = Map.merge(head.pages, pages)
                    head = head |> Map.put(:pages, pages)
                    :dets.insert(__MODULE__, {id, head})
                end
        end
        noreply
    end

    defcast log({:download_time, %{id: id, download_time: download_time} = msg}), state: state do
        Logger.debug "#{inspect __MODULE__} msg:#{inspect msg}"
        case :dets.lookup(__MODULE__, id) do
            [] -> :dets.insert(__MODULE__, {id, msg})
            [{^id, head} | tail] ->
                head = head |> Map.put(:download_time, download_time)
                :dets.insert(__MODULE__, {id, head})
        end
        noreply
    end

    defcall get({:all_data}), state: state do
        Logger.debug "log manager get"
        reply(:dets.foldl(fn {id, args}, map -> Map.put(map, id, args) end, %{}, __MODULE__))
    end

    defcast log(msg), state: state do
        Logger.debug "#{inspect __MODULE__} msg:#{inspect msg}"
        noreply
    end
end