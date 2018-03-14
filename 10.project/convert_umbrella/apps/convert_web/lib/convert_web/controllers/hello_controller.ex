defmodule ConvertWeb.HelloController do
    use ConvertWeb, :controller
  
    require Logger
    import Phoenix.Naming

    def hello(conn, msg) do
        conn |> json(ok(%{}))
    end


    def node_test(conn, msg) do
        msg = Node.connect :"ke@192.168.2.56"
        
        Logger.debug "#{inspect msg}"
        Logger.debug "#{inspect Node.self}"
        Logger.debug "#{inspect Node.list}"
        Logger.debug "#{inspect Node.get_cookie}"
        conn |> json(ok(%{}))
    end

end