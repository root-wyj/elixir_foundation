defmodule MyPhx.Application do
  @moduledoc """
  The MyPhx Application Service.

  The my_phx system business domain lives in this application.

  Exposes API to clients such as the `MyPhxWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      
    ], strategy: :one_for_one, name: MyPhx.Supervisor)
  end
end
