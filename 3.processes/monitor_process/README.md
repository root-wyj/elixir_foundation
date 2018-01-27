# MonitorProcess

进程之间的关系。

- `spawn` 没有关系。这种方式启动的进程各自运行，谁都不影响谁。

- `spawn_link` 关联关系。 当两个进程被关联，任何一个都会接收到另外一个退出的消息。`spawn_link` 将 创建一个进程并与调用者关联 合并成一个操作。也可以通过`Process.link` 来关联两个进程。

- `spawn_monitor` 监控关系。一个进程创建另一个进程，而且能接收其退出的消息，反之则不然。这种关系是单向的。 `Process.monitor` 也可以监控一个进程。当被监控进程退出的时候，监控进程都能收到消息`{:DOWN, Reference, :process, PID, :reason}`

> A通过`spawn_link` 方式启动的进程B，当进程B正常退出`:nomal`的时候，进程A并不会收到任何消息。当非正常退出`非 :normal`的时候，所有和Blink的进程，包括A都会crash。如果A调用了`Process.flag(:trap_exit, true)`，那么A不会奔溃，并会收到B发来的消息`{:EXIT, #PID<0.76.0>, :boom}`。除了`:normal` 都是非正常的退出方式。

> A通过`spawn_monitor`方式启动的进程B。当B退出的时候（无论正常还是不正常），会向A发送退出的消息`{:DOWN, Reference, :process, PID, :normal}`。在OTP中，`exit(:normal) 、 exit(:shutdown) 、 exit({:shutdown, tem})`都被认为是正常的。

> `CLI exits` [文档](https://hexdocs.pm/elixir/Kernel.html#exit/1)中提到的，应该是指的命令行的环境。


注意，通过`elixir -r xx.ex -e Module.fn`来运行的时候，是符合上述规范的。但是在`iex [xx.ex]`环境中，编译运行`spawn_link`的进程并不会退出，而是收到一个消息`{:EXIT, #PID<0.76.0>, :boom}`



