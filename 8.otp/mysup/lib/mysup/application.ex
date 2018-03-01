defmodule Mysup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  # 整体结构
  # 因为数据存储在GenServer中的话，如果GenServer停掉，重启之后数据也没了
  # 所以，需要把数据保存在其他地方，并在GenServer重启的时候恢复
  
  # 保存GenServer state的GenServer由总监视器Mysup.Supervisor来直接监视
  # Mysup.SubSupervisor是用来监视各个GenServer服务的，防止服务停止。并且它也由总监视器监视

  use Application

  # 注意该方法对返回值有要求
  def start(_type, _args) do
    Mysup.Supervisor.start_link()
    # List all child processes to be supervised
    # children = [
      # Starts a worker by calling: Mysup.Worker.start_link(arg)
      # {Mysup.Worker, arg},
    # ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    # opts = [strategy: :one_for_one, name: Mysup.Supervisor]
    # Supervisor.start_link(children, opts)
  end
end
