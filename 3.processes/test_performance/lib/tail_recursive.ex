defmodule TailRecursive do
  @moduledoc """
  尾递归

  递归在编程中通常都会有栈，用来保存和恢复现场，在很多层递归之后，内存就会被消耗很多。
  在Elixir中并不会发生，它实现了“尾递归优化”。
  如果函数的最后一件事是调用自己，那就没有必要调用，只不过简单的跳转到函数的开始位置。
  如果有参数，那就替换掉原始的参数，像循环一样。（这些优化 都是因为尾递归不需要保存现场
  而且如果不是尾递归的话，也非常占用内存）
  """

  # 以阶乘为例子

  # 这个例子中并不是尾递归，虽然函数调用写在后面，但是并不是最后执行的。
  def _recurisive(1) do
    1
  end

  def _recurisive(n) do
    n * _recurisive(n - 1)
  end

  # 尾递归的例子
  def _tail_recurisive(n) do
    _tail_recurisive(n, 1)
  end

  def _tail_recurisive(0, result) do
    result
  end

  def _tail_recurisive(m, result) do
    _tail_recurisive(m - 1, result * m)
  end

  @doc """
  测量耗时
  """
  def use_time(fun, args) do
    start_time = Time.utc_now()
    result = fun.(args)
    end_time = Time.utc_now()
    IO.puts("use time: #{Time.diff(end_time, start_time, :second)}, result:#{inspect(result)}")
  end
end
