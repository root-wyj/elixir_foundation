defmodule Myagent do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
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
