defmodule Convert.Application do
  @moduledoc """
  The Convert Application Service.

  The convert system business domain lives in this application.

  Exposes API to clients such as the `ConvertWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # List all child processes to be supervised
    children = [
      supervisor(StatusManager, []),
      supervisor(ConvertManager, []),
      supervisor(ConvertQueue, []),
      supervisor(ConvertWorkerContainer, []),
      supervisor(ConvertPageManager, []),
      supervisor(ConvertPageQueue, []),
      supervisor(ConvertWorkerPageContainer, []),

      supervisor(LogManager, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [
      max_seconds: 1,
      max_restarts: 1_000_000,
      strategy: :one_for_one,
      name: Convert.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
