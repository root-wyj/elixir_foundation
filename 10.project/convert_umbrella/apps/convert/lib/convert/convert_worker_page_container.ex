defmodule ConvertWorkerPageContainer do
    use ExActor.GenServer, export: __MODULE__

    require Logger

    # set_and_reply(new_state, response)
    # reply(response)
    # new_state(new_state)
    # noreply

    defmodule PageContainer do
        defstruct key: nil, pid: nil, from: []
    end 

    defstart start_link() do
        Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect ConvertWorkerPageContainer}"

        # map. key id_page; value PageContainer
        initial_state(%{})
    end

    defcall add_worker(%{"id" => id, "page" => page, "from" => from} = params, pid), state: state do
        Logger.debug "page container add #{inspect params}, #{inspect pid}"
        key = id<>"_"<>page
        b = true
        page_container = Map.get(state, key)
        page_container = case page_container do
            nil ->
                b = true
                %PageContainer{key: key, pid: pid, from: [from]}
            _ ->
                b = false
                list = page_container |> Map.get :from
                page_container |> Map.put :from, [from | list]
        end

        state = state |> Map.put(key, page_container)

        set_and_reply(state, {:ok, b})
        
    end

    defcall contains(%{"id" => id, "page" => page, "from" => from} = params), state: state do
        key = id<>"_"<>page
        reply {:ok, Map.has_key?(state, key)}
    end

    defcall merge(%{"id" => id, "page" => page, "from" => from}=params), state: state do
        #因为 containes 和 merge 并不是 原子操作，所以这里可能会报错
        key = id<>"_"<>page
        page_container = Map.get(state, key)

        case page_container do
            nil ->
                reply({:ok, false})
            _ ->
                list = page_container |> Map.get :from
                page_container = page_container |> Map.put :from, [from | list]
                state = state |> Map.put(key, page_container)
                set_and_reply(state, {:ok, true})
        end

        
    end

    defcall remove(id, page), state: state do
        key = id<>"_"<>page;
        Logger.debug "page container delete #{key}"
        case Map.get(state, key) do
            nil ->
                reply {:ok, []}
            page_container ->
                list = page_container.from
                state = state |> Map.delete(key)
                set_and_reply(state, {:ok, list})
        end
    end

    defcall worker_size(), state: state do
        reply(map_size(state))
    end


end