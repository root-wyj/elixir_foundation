defmodule FibserverTest do
  use ExUnit.Case
    setup do
      pid_server = spawn_link(FibServer, :scheduling, [])
      pid_client = spawn_link(FibClient, :start_caculate, [])
      %{pid_client: pid_client, pid_server: pid_server}
    end

    test "client and server", %{pid_client: pid_client, pid_server: pid_server} do
      spawn(FibServer, :ready, [pid_server, pid_client])
    end

end
