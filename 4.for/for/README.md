###About ExUnit Test

1. Start ExUnit

```elixir
ExUnit.start
```
2. Create a new test module(test case)

```elixir
defmodule AssertTest do
    use ExUnit.Case, async: true

    test "the truth" do
        assert true
    end

end
```

the end, use `mix test` start your test. The command will run the test in each file matching the pattern `*_test.exs` found in the `test` directory.

> must create a `test_helper.exs` file inside the test directory and put the code common to all tests there

for most simple example:
```elixir
ExUnit.start
```

for more infomation about test, goto [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html) 

###关于 节点 -- Node

两个节点之间的通信
1. pc1 以显示命名节点的方式启动 `iex --cookie 123 --name wu@192.168.2.230 -S  mix phx.server`，同样的启动pc2 `iex --cookie 123 --name ke@192.168.2.56 -S  mix phx.server`。注意，cookie 必须是相同才能通信，而且name 后面的地址必须是全的。
2. 建立连接 `Node.connect :"ke192.168.2.56"`. `Node`也是一个工具库，例如查看已建立连接的列表 `Node.list`
3. 通信。`send {ConvertManager, :"ke@192.168.2.56"}, %{stream: stream, msg: msg}`

`ConvertManager`是一个模块的名称，包含的要点如下：
```elixir
defmodule ConvertManager do
    #必须像这里一样 引入包（有什么作用，暂时还不知道）
    use ExActor.GenServer, export: __MODULE__

    #这样来响应消息
    def handle_info(%{msg: msg, stream: stream}, state) do
        #... 处理消息

        #需要这样返回消息
        {:noreply, state}
    end
end
```

send {ConvertManager, :"ke@192.168.2.56"}, %{msg: "hello"}
