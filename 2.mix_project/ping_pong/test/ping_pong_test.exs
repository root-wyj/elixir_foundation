defmodule PingPongTest do
  use ExUnit.Case
  doctest PingPong

  test "greets the world" do
    #spawn 函数接受一个模块，函数和list的参数
    #然后会启动一个新的进程，来运行这个函数，当这个函数执行完之后，这个进程就死了。
    #返回值是 pid
    ping = spawn(Ping, :start, [])

    #向pid为ping的进程发送一个消息
    #self() 表示当前进程的pid
    send(ping, {:pong, self()})

    #我们期望在发送一个消息之后，在100ms（assert_receive方法内部指定的）能收到一
    #:ping的消息，否则失败
    assert_receive {:ping, ^ping}

    send(ping, {:pong, self()})
    assert_receive {:ping, ^ping}
  end
end
