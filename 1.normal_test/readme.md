###环境安装

elixir是基于erlang虚拟机的，所以首先需要`安装erlang`，然后`安装elixir`，都可以去官网上下载。

- [elixir 官网](https://elixir-lang.org/)
- [erlang 官网](http://www.erlang.org)

[erlang -> elixir -> phoenix 安装教程](https://hexdocs.pm/phoenix/installation.html#content)

安装完成之后，输入`erl -version`检查erlang环境是否安装完成，`iex -v`检查elixir是否安装完成。

####完成第一个程序

如上编写 `hello.exs` （elixir的类脚本文件），使用命令`elixir hello.exs`运行并查看结果。


###了解elixir

#### elixir是函数式编程


#### 函数编程中的`转换`思维



#### elixir的角色模式



#### elixir的匹配模式

####What is the Actor Model?
An actor is an object that has its own lifecycle and lives concurrently. An actor communicates with another actor by placing a message in his mailbox. The second actor can then read the mailbox in his preferred order, and respond to the messages at his leisure. This is a large part of the Erlang 'shared nothing' model, and one of the core concepts that leads to its fault tolerance and ease of distribution.

更多信息可以参考：http://channel9.msdn.com/Shows/Going+Deep/Hewitt-Meijer-and-Szyperski-The-Actor-Model-everything-you-wanted-to-know-but-were-afraid-to-ask

#### Orders
在命令行输入`iex`进入elixir的操作命令行页面。

也可以新建一个hello.exs 之后通过`elixir hello.exs`直接运行程序
