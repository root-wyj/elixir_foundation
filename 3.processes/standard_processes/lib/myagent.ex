defmodule Myagent do
  use Agent

  def start_link(_opts) do
    # 可以通过在opt参数中为pid指定名字，但最好不要这么做，如果用atom作为pid的名字，那么通常可能会将一些容器name转为atom，
    # 很可能会是用户的输入转换为atom，而atom是不会被回收的，而用户的输入又是不可控的，所以很可能造成许多的垃圾（有时候为了防止atom数量太多，可以设置系统参数来控制VM的atom）
    Agent.start_link(fn -> %{} end, name: :shopping)
  end

  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
    #相当于 Agent.get(bucket, fn map -> Map.get(map, key)) end)
    #具体文档可以参考 https://elixir-lang.org/getting-started/modules-and-functions.html#function-capturing
  end

  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end
end
