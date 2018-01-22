defmodule Message_Upcaser do
    def upcase(server_pid, str) do
        #返回一个唯一的引用
        ref = make_ref()
        # IO.puts(ref)
        # send the server a request to upcase
        send(server_pid, {self(), ref, {:upcase, str}})
        #Then will block, waiting to get a response.
        receive do
            {:ok, ^ref, str} -> {:ok, str}
        end
    end

    def upcase_server do
        receive do
            {client_id, ref, {:upcase, str}} ->
                send(client_id, {:ok, ref, String.upcase(str)})
        end
        upcase_server
    end
end