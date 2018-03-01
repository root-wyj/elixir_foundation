defmodule MyNode do
  
  defmodule Ticker do
    @interval 2000
    @name :ticker

    def start() do
      pid = spawn_link(MyNode.Ticker, :generator, [[], []])
      :global.register_name(@name, pid)
      {:ok, pid}
    end

    def register(pid_client) do
      send :global.whereis_name(@name), {:register, pid_client}
    end

    def generator(clients, clients_cp) do
      receive do
        {:register, pid_from} ->
          IO.puts "registed #{inspect pid_from}"
          clients = [pid_from | clients]
          clients_cp = [pid_from | clients_cp]
        after @interval ->
          IO.puts "tick"
          if (length(clients_cp) > 0) do
            [head | tail] = clients_cp
            send head, {:tick}
            if (length(tail) == 0) do
              clients_cp = clients
            else
              clients_cp = tail
            end
          end
      end
      generator(clients, clients_cp)
    end
  end

  defmodule Client do

    def start_and_register() do
      IO.puts "registing"
      MyNode.Ticker.register(spawn_link(fn -> rece() end))
    end

    def rece do
      receive do
        {:tick} ->
          IO.puts "tock"
      end
      rece()
    end
  end

  #test
  #以指定node方式运行iex `iex --sname node_one --cookie mycookie`
  #然后Node之间建立连接 `Node.connect :"node_one@jie"`
  #可以通过`Node.list`查看已建立连接的列表
  #
  #在一个iex中启动server `MyNode.Ticker.start()`
  #在另外一个iex中，启动并注册client `MyNode.Client.start_and_register()`
  #
  #
end
