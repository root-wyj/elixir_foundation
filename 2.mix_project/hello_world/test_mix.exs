defmodule Mix.Task.Hello2 do
    use Mix.Task

    def run(_) do
        Mix.shell.info "hello"
    end

end