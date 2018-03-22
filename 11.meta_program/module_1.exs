defmodule MyModule do
    @custom "xixi haha"

    @before_compile MyModule2

    @on_definition {MyModule2, :on_def}

    @after_compile __MODULE__

    def __after_compile__(env, bytecode) do
        IO.puts("env:#{inspect env}, bytecode:#{inspect bytecode}")
    end

    
end