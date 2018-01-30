# MySupervision

Supervisor beahaviour(行为)

A behaviour module for implementing supervisors.

监管者是一个监管其他子进程的进程。通常用来构建分层的进程结构也叫作 监管树。监管树提供了一定的容错和封装在程序启动和关闭的时候。

### Start and Shutdown

下面是定义Supervisor的基本代码。

```elixir
defmodule MySupervision do
    use Supervisor

    def start_link(opts) do
        Supervisor.start_link(__MODULE__, :ok, opts)
    end

    #callback
    def init(:ok) do
        children = [
            %{
                id: Stack,
                start: {Stack, :start_link, [[]]}
            }
        ]

        Supervisor.init(children, strategy: :one_for_one)
    end
end
```

当Supervisor启动的时候，会遍历并检查所有孩子的规范。就是这时候通过调用`Stack.child_spec([])`将这些变成了child的规范。

Supervisor会按照孩子定义的顺序启动。启动会按照`%{id:Stack, start: {Stack, :start_link, [[]]}}` 这个定义启动。并且必须返回`{:ok, pid}`。

当Supervisor关闭的时候，按照孩子定义的相反顺序关闭。通过发送 `Process.exit(child_pid, :shutdown)`消息来关闭。如果超过了默认的时间间隔5s（这个时间间隔，一是消息发送出去后的5s，二是child开始处理这个消息，5s之内需要处理完。我也不太清楚是哪个），Supervisor会突然关闭child，原因返回`:brutal_kill`。

如果process不是 trapping exits（`Process.flag(:trap, true)`），会在收到消息之后立刻关闭。如果是，`terminate`回调会被调用，但是方法执行的耗时必须在 时间间隔之内。

> 其实应该仔细研究一下 reason、trap_flag与 terminate 回调之间的关系。







### 编译并启动project

`mix compile` 编译app

可以在 `_build/dev/lib/appname/ebin/`找到 `appname.app`的文件
这个文件保存着应用的定义。比如应用 `version`，所有定义的模块`{modules,['Elixir.MySupervision','Elixir.Stack']}`，所有的依赖 `{applications,[kernel,stdlib,elixir,logger]`和额外的依赖等，这些都可以在`mix.exs`中去自定义，（甚至直接修改该`.app`文件？）

`iex -S mix` 启动工程

也可以通过指令`iex -S mix run --no-start`不启动，而在 命令行中 另外启动 `Application.start(:my_supervision)`



