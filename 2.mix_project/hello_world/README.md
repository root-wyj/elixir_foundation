# HelloWorld

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hello_world` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hello_world, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hello_world](https://hexdocs.pm/hello_world).

# learn about mix

命令：

- `mix help` 查看mix所有命令帮助，也可以通过 `mix help new` 查看某一个命令的帮助(该命令的帮助文档真的是详细)
- `mix new hello_world` 创建一个新的工程
- `mix new --sup hello_world` 创建一个带应用程序监视器的工程
- `tree /F` 查看 工程文件结构。通过`help tree`详细了解tree的参数使用
- `mix test` 直接运行测试文件，检查是否运行成功
- `iex -S mix` 编译工程。注意该命令要与`mix.exs` 文件同级目录。想要运行我们写的代码，就需要先编译，变成机器可以识别的文件，然后直接调用`Module.fn`执行某个方法。因为elixir是运行在erlang虚拟机上的，像jvm一样的，需要先编译成字节码文件才能运行。 `.exs`文件又被解释成脚本文件，所以他应该是可以直接运行的。（***`TODO` 但是我还不知道怎么直接运行*）