defmodule ConvertWorker do
  require Logger
  alias Entice.Entity

  defmodule Args do
    defstruct id: nil, url: nil, type: nil
  end

  def start(args) do
    Logger.debug "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
    *****#{inspect args}"
    {:ok, pid} = Entity.start()
    args = %Args{id: args["id"], url: args["url"], type: args["type"]}
    Entity.put_behaviour(pid, ConvertWorker.Behaviour, args)
    {:ok, pid}
  end

  defmodule Behaviour do
    use Entice.Entity.Behaviour

    def init(entity, args) do
      entity = entity |> put_attribute(args)
      send(self, {:start, %{}})
      {:ok, entity}
    end

    def handle_event({:start, msg}, entity) do
      msg = entity.attributes[Args] |> Map.from_struct()
      Logger.debug("msg:#{inspect(msg)}")

      case Convert.convert(msg) do
        {:ok, target_path} ->
          send(self(), {:stop, %{reason: "success"}})
        {:error, msg} ->
          send(self(), {:stop, msg})
      end
      {:ok, entity}
    end

    def handle_event({:stop, msg}, entity) do
      exit(:normal)
    end

    def handle_event(topic, entity), do: {:ok, entity}

    def terminate(reason, entity) do
      Logger.debug("terminate #{inspect(reason)}")
      args = entity.attributes[Args] |> Map.from_struct
      Logger.debug "args: #{inspect args}"
      ConvertManager.decrement(args)
      {:ok, entity}
    end
  end
end
