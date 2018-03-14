defmodule ConvertPageWorker do
    require Logger
    alias Entice.Entity

    defmodule Args do
        defstruct id: nil, page: nil, type: "pdf"
    end

    def start (params) do
        Logger.info "start a new page worker"
        {:ok, pid} = Entity.start
        args = %Args{id: params["id"], page: params["page"]}
        Entity.put_behaviour(pid, ConvertPageWorker.Behaviour, args)
        {:ok, pid}
    end

    defmodule Behaviour do
        use Entice.Entity.Behaviour

        def init(entity, args) do
            entity = entity |> put_attribute(args)
            send self(), {:start, %{}}
            {:ok, entity}
        end

        def handle_event({:start, msg}, entity) do
            msg = entity.attributes[Args] |> Map.from_struct()
            case Convert.convert_page(msg) do
                {:ok, _info} ->
                    send self(), {:stop, %{reason: "success"}}
                {:error, reason} ->
                    send self(), {:stop, %{reason: reason}}
            end
            {:ok, entity}
        end

        def handle_event({:stop, %{reason: reason}}, entity) do
            Logger.debug "page_worker stop, reason:#{inspect reason}"
            exit :normal
        end

        def handle_event(msg, entity) do
            {:ok, entity}
        end

        def terminate(reason, entity) do
            Logger.debug "page_worker terminal. reason:#{inspect reason}"
            args = entity.attributes[Args] |> Map.from_struct
            ConvertPageManager.decrement(args)
            {:ok, entity}
        end
    end
end