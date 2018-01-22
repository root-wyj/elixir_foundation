# PingPong

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ping_pong` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ping_pong, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ping_pong](https://hexdocs.pm/ping_pong).


#Agent
Elixir 是一种不可改变的语言。所以默认的所有的数据都不是共享的。在Elixir中，提供了两种方式来在多个地方修改和获取一份数据
- Processes
- ETS(Erlang Term Storage)

###Processes
如果使用`Processes`，我们很少自己手动处理，我们使用下列抽象的方便使用的：
- `Agent` Simple wrappers around state. If all you want from a process is to keep state, agents are a great fit.
- `GenServer`
- `Task`

总任务安排：
1. 看完 `elixir程序设计`
2. 看完 `java并发编程`

离过年还有4周，根据上面两本书的难易程度，暂时这样安排。
`elixir程序设计`用一周（01.15-01.21）的时间看完
`java并发编程` 用两周（01.22-02.04）时间看完
剩下基本还有一周的时间，这一周 就可以大致回顾一下，或者是玩一玩什么的。

这周任务安排：
elixir 这本书共分为 3大章节 -- `常规`,`并发`,`高级`
前三天（15号-17号）看常规编程部分，一共13章，但都是基本语法什么的，很快。
后三天（18号-20号）看并发编程部分，一共6章，2天看完，剩下一天用来复习回顾。
最后一天，暂定，总结。如果，掌握程度比较好，可以看一下最后一大章，高级部分，共4章，50页，不是很多。