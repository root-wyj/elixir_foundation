defmodule EchoServerNormal do
    require Logger

    # for test
    # run `iex echo_server_normal.ex` 编译该文件
    # run `EchoServerNormal.accept 4040` 启动监听服务
    # 在新的命令窗口中 `telnet 127.0.0.1 4040` 建立连接，然后就可以收發消息了

    # Task.Supervisor.start_child(supervisor, fun)

    def accept(port) do
        # The options below mean:
        #
        # 1. `:binary` - receives data as binaries (instead of lists)
        # 2. `packet: :line` - receives data line by line
        # 3. `active: false` - blocks on `:gen_tcp.recv/2` until data is available
        # 4. `reuseaddr: true` - allows us to reuse the address if the listener crashes
        #
        {:ok, socket} = :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

        Logger.info "accepting connections on port:#{port}"

        loop_acceptor(socket)
    end

    defp loop_acceptor(socket) do
        {:ok, client} = :gen_tcp.accept(socket)
        welcome(client)
        Task.Supervisor.start_child(MyTask.Task.Supervisor, fn -> server(client) end)
        loop_acceptor(socket)
    end

    defp welcome(client) do
        :gen_tcp.send(client, "welcome to my :gen_tcp\r\n")
        Logger.info("client:#{inspect client} conn in")
    end

    defp server(client) do
        {:ok, line} = :gen_tcp.recv(client, 0);
        Logger.debug "accept from client: #{line}"
        # Enum.map(line, fn c -> IO.puts c end)
        case line do
            "exit" ->
                :gen_tcp.send(client, "client close the connection\r\n");
                :gen_tcp.close(client)
            "exit\r\n" ->
                :gen_tcp.send(client, "client close the connection\r\n");
                :gen_tcp.close(client)
            _ ->
                :gen_tcp.send(client, line)
                server(client)
        end
        
    end



end