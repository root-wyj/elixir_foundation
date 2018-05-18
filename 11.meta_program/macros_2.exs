defmodule MyMacro2 do
    
    defmacro defkv(kv) do
        IO.puts(inspect kv)
        quote bind_quoted: [kv: kv] do
            IO.puts(inspect kv)
            Enum.map(kv, fn {k,v} ->
                IO.puts("#{inspect k}, #{inspect v}")
                def unquote(k)(), do: unquote(v)
            end)
        end
    end

end

defmodule MyMacro2.Test do
    require MyMacro2

    kv = [foo: 1, bar: 2]

    # way 1
    # MyMacro2.defkv([foo: 1, bar: 2])
    MyMacro2.defkv(kv)

end

IO.puts(MyMacro2.Test.foo)