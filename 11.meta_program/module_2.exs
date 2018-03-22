defmodule MyModule2 do
    
    #作为其他模块 编译之前的回到函数
    defmacro __before_compile__(env) do
        quote do
            def hello, do: "world"
        end
    end

    # 作为其他模块 每一个函数或macro被定义是的回调
    def on_def(env, kind, name, args, guards, body) do
        IO.puts "Defining #{kind} named #{name} with args:"
        IO.inspect args
        IO.puts "and guards"
        IO.inspect guards
        IO.puts "and body"
        IO.puts Macro.to_string(body)
    end
    
end