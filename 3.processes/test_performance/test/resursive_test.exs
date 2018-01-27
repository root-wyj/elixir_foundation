defmodule ResirsiveTest do
  use ExUnit.Case, async: true

  test "jiecheng resursive" do
    fun = &TailRecursive._recurisive/1
    TailRecursive.use_time(fun, 100)
  end

  test "jiecheng tail_resursive" do
    fun = &TailRecursive._tail_recurisive/1
    TailRecursive.use_time(fun, 100)
  end
end
