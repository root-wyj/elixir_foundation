defmodule MyPhxWeb.HelloController do
    use MyPhxWeb, :controller

    require Logger
    import Phoenix.Naming

    plug :put_headers, %{content_encoding: "gzip", cache_control: "max-age=3600", "Access-Control-Allow-Origin": "*"}

    def hello(conn, msg) do
        Logger.info "conn:#{inspect conn}"

        conn |> json(ok("success"))
    end

    def test_json(conn, msg) do
        str = "{\"name\": \"xiaoming\", \"age\":17}"
        {:ok, json} = Poison.Parser.parse(str)
        Logger.info "json:#{inspect json}"
        conn |> json(error("204", json))
    end

    def test_http(conn, msg) do
        all = HTTPoison.get("http://www.baidu.com")
        Logger.info "all:#{inspect all}"
        conn |> json(ok(inspect all))
    end

    def put_headers(conn, maps) do
        maps |> Enum.reduce(conn, fn {k, v}, conn ->
            Logger.info "k:#{inspect k}, v:#{inspect v}"
            Plug.Conn.put_resp_header(conn, to_string(k), v)
        end)
    end
    
end