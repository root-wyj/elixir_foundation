# GenServer

A behaviour module for implementing the server of a client-server relation.

GenServer像其他的Elixir的进程一样，可用来保存状态、执行异步代码、序列化执行操作等等。他的优势在于有一套标准的接口方法定义 包括了方法追踪和错误报告。并且也适合 监管树。





- 一个GenServer通常是由两部分组成，客户端的API和server端的callback。这两部分可能在也可能会不在一个文件中，但他们都运行在不同的Processes中。客户端传递消息给服务端，服务端（在一个进程中）序列化请求消息，并处理，保证数据的一致性。

- GenServer可以接收两种请求：`calls`和`casts`。`Calls` 是同步的并且服务器必须发出响应给这样的请求。`Casts`是异步的，服务器也不需要返回一个Response。

- `GenServer.call` 和 `GenServer.cast` 都可以发送请求。通过定义函数`handle_call/3` 和 `handle_cast/2` 来处理消息。

- `GenServer.handle_info(msg, state)` 处理所有其他的消息的。比如说被监视的进程退出后发出的`:DOWN`消息。

- `{:reply, reply, new_state}` or `{:noreply, new_state}`

4. `init/1` callback。这个回调是用来响应 `GenServer.start_link/3`请求的， 并且返回了`{:ok, state}`.这个 `status`贯穿了整个服务器回调，在每一个回调函数中都有（就是第三个参数 status）

5. 还有其他的一些回调，例如 `terminate/2` 和 `code_change/3`等

6. 更多详细的可以参考文档 [hexdocs_GenServer](https://hexdocs.pm/elixir/GenServer.html)
