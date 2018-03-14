defmodule StatusManager do
  use ExActor.GenServer, export: __MODULE__

  require Logger

  defstart start_link do
    Logger.debug "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
    #{inspect StatusManager}"
    initial_state(0)
  end

  defcall isConverted(%{"id" => id} = params), state: state do
    
    metaPath = "/Documents/" <> id <> "/meta.json"
    Logger.debug "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
    #{inspect metaPath}"
    case File.read(metaPath) do
      {:ok, resp} -> 
        {:ok, json} = Poison.Parser.parse resp
        reply({:ok, %{meta: json}})
      {:error, what} ->
        Logger.debug "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
        #{inspect what}"
        reply({:error, what})
    end
    
  end
end
