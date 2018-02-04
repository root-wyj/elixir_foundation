#Processes

Elixir的核心就是进程，所有的函数都运行在某个进程当中，所有的数据也以进程的状态的方式来保存，通信也是通过进程之间发消息来实现的。进程是Elixir的一切。


###spawn
以`spawn`的方式启动一个进程。

- `Kernel.spawn(fun)` 只接受一个函数作为参数
- `Kernel.spawn(module, :fun, args)` 还是一个函数，更灵活了。

**返回值是 `pid`**

另外，`Kernel`模块还提供了`spawn_link`和`spawn_monitor`函数，但是参数和上面是一致的。

- `Process.spawn(fun, opts)` 增加了opts。具体参数可以看erlang的文档。`opts`参数可以默认传`[]`
- `Process.spawn(module, :fun, args, opts)` 还是一个函数。

**返回值 `pid() | {pid(), reference()}`** 这里的返回值和erlang中的spawn是一致的。

> 为什么`Process`模块不提供`spawn_link`、`spawn_monitor`这种函数？ 因为它提供了`opts`参数，该参数直接和erlang中`:erlang.spawn_opts/4`中的`opts`参数直接挂钩的，而通过该参数是可以指定`link`和`monitor`参数的。

所以，在Elixir中，通过`spawn`启动的函数，是不能直接注册name的，可以通过`Process.register(pid() | port(), atom)`来注册名字。

Elixir对process还封装了`Agent`、`GenServer`、`Task`。

###Agent
`Agent`是Elixir对process的封装

#####启动
`start(fun, options \\ [])` 或者更灵活的 `start(module, fun, args, opts \\ [])` 或者 `start_link(...)`。

> 这里的参数`opts`和`Process`中的就不一样了。Elixir对`opts`参数做了封装。

参数`opts`：
- `[name: atom]` 可以通过定义的name来向该进程发送消息，也可以通过`Process.whereis/1`来获取pid
- `[timeout: 1000]` 最多1000ms完成初始化，start函数返回`{:error, :timeout}`
- `:spawn_opt` 这个参数的值和`Process`中的opts参数直接挂钩

#####其他
- 更新 `cast`、`get`、`update`、`get_and_update`、`stop`等

###GenServer

#####函数：
- `start`、`start_link`和`Agent`模块的差不多
- `call`同步调用。`cast`异步调用
- `stop` 同步停止某GenServer
- `reply/2` 更加灵活的给客户端服务端返回数据
还有其他丰富的函数，可以看Elixir的文档

#####回调
**注意回调的参数 都要有 `state`**
- `handle_call` call的同步回调、`handle_cast` cast异步回调、`handle_info`处理其他消息。返回值有 `{:reply, reply, new_state} | {:reply, reply, new_state, timeout() | :hibernate} | {:noreply, new_state} | {:noreply, new_state, timeout() | :hibernate} | {:stop, reason, reply, new_state} | {:stop, reason, new_state}`
- `init(state)` 初始化的回调。通常返回 `{:ok, state}`，`start_link`也会返回`{:ok, pid}`。
- `terminate/2` stop之后该进程会停止，停止之前会回调该函数
- `code_change/3` 代码发生变化的时候


