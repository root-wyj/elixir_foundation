defmodule Message do
    def upcase_server do
        loop(&Message.upcase_listener/0)
    end

    def upcase_listener do
        receive do
            {:upcase, {msg, pid_from}} ->
                resultMsg = String.upcase(msg)
                IO.puts("receive msg:"<>msg)
                send(pid_from, {:ok, resultMsg})
        end
    end


    def loop(f) do
        f.()
        loop(f)
    end

    def response_server do
        loop(&Message.response_listener/0)
    end

    def response_listener do
        receive do
            {:ok, resultMsg} ->
                IO.puts("get response:"<>resultMsg)
        end
    end

end
