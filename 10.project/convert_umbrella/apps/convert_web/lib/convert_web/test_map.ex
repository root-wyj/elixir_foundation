defmodule HostMap do
    require Logger

    @hosts %{
        [] => {:error, "已拆分"},
        [0] => {:error, "已拆分"},
        [0, 0] => {:ok, "192.168.2.1"},
        [0, 1] => {:error, "已拆分"},
        [0, 1, 0] => {:ok, "192.168.2.4"},
        [0, 1, 1] => {:ok, "192.168.2.5"},
        [1] => {:ok, "192.168.2.3"},
    }

    @divisor 2

    def map(id) when is_integer(id) do
        
        map_(id)
    end

    defp map_(id_div, list \\ []) do
        case Map.get(@hosts, list) do
            nil ->
                throw "config error"
            {:error, _} ->
                map_(div(id_div, @divisor), List.insert_at(list, length(list), Integer.mod(id_div, @divisor)))
            {:ok, host} ->
                host
        end
    end

end