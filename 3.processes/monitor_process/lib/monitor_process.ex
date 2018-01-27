defmodule MonitorProcess do
    
  #而且一个退出，另一个也会退出。如果通过`Process.flag(:trap_exit, true)` 来捕捉

  def sad_fun do
    :timer.sleep 500
    exit(:normal)
    # exit(:boom)
  end

  #启动一个毫不相关的进程
  def test1 do
    # 返回false
    IO.puts "#{inspect Process.flag(:trap_exit, true)}"
    spawn(MonitorProcess, :sad_fun, [])
    receive do
      msg ->
        IO.puts "receive msg: #{inspect msg}"
      after 1000 ->
        IO.puts "Nothing happened"
    end
    
  end

  #启动一个关联进程
  def test2 do
    #Sets the given flag to value for the calling process.
    #Returns the old value of flag.
    # 这个标志设置为true的话，就不会异常退出了
    # 并且捕捉到 退出的连接进程发过来的消息 {:EXIT, #PID<0.76.0>, :boom}
    # IO.puts "#{inspect Process.flag(:trap_exit, true)}"
    spawn_link(MonitorProcess, :sad_fun, [])
    receive do
      msg ->
        IO.puts "receive msg: #{inspect msg}"
      after 1000 ->
        IO.puts "Nothing happened"
    end
    :timer.sleep 1000
  end
  
  # 启动一个被监视进程
  # 被监视进程退出，会给监视进程发送消息，如下
  # {:DOWN, #Reference<0.2838974087.2641100808.136290>, :process, #PID<0.76.0>, :boom}
  def test3 do
    #这里没起到作用
    # IO.puts "#{inspect Process.flag(:trap_exit, true)}"
    spawn_monitor(MonitorProcess, :sad_fun, [])
    receive do
      msg ->
        IO.puts "receive msg: #{inspect msg}"
      after 1000 ->
        IO.puts "Nothing happened"
    end
    
  end
end
