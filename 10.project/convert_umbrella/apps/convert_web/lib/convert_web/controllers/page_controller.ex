defmodule ConvertWeb.PageController do
    use ConvertWeb, :controller

    require Logger
    require Phoenix.Naming

    # plug :put_headers, %{"Access-Control-Allow-Origin": "*",
    #                      "Access-Control-Max-Age": "3600",
    #                      "Access-Control-Allow-Headers": "Origin,Accept,X-Requested-With,Content-Type,Access-Control-Request-Method,Access-Control-Request-Headers,Authorization",
    #                      "Access-Control-Allow-Methods": "POST,GET,OPTIONS,DELETE,PUT"}

    def get_page(conn, %{"id" => id, "page" => page} = params) do
        Logger.debug "getpage params: #{inspect params}"

        base_path = Application.get_env(:convert, :file_convert_dir)
        path = base_path
        |> Path.join id
        |> Path.join "page"
        |> Path.join page

        case path |> File.exists? do
            true ->
                send_download(conn, {:file, path}, [])
                # send_resp(conn, 200, "success")
            false ->
                page = params["page"]
                [_head|[num|_tail]] = String.split(page, ["-", "."])
                params = params |> Map.put("page", num)
                    |> Map.put("type", "pdf")
                    |> Map.put("url", "http://221.122.117.73/getpdftestd73b80b7c0890ec.jsp?file=" <> id)
                    |> Map.put("from", self())
                ConvertPageManager.start_worker(params)
                case wait_for_notify(path) do
                    {:ok, _msg} ->
                        send_download(conn, {:file, path}, [])
                    {:error, code, _msg} ->
                        send_resp(conn, code, _msg)

                end
                # params = params |> Map.put("page", page)
                # get_page(conn, params)
                # send_resp(conn, 404, "")
        end
        
    end

    defp wait_for_notify(path) do
        receive do
            {:ok, msg} ->
                case path |> File.exists? do
                    true ->
                        {:ok, msg}
                    false ->
                        {:error, 404, inspect msg}
                end
            {_p1, _p2} ->
                Logger.info "controller response error p1:#{inspect _p1}, p2:#{inspect _p2}"
                {:error, 404, ""}
            after 15000 ->
                {:error, 500, "timeout"}
        end
    end

    def get_font(conn, %{"id" => id, "font" => font} = params) do
        base_path = Application.get_env(:convert, :file_convert_dir)
        path = base_path
        |> Path.join id
        |> Path.join "font"
        |> Path.join font

        case path |> File.exists? do
            true ->
                send_download(conn, {:file, path}, [])
            false ->
                send_resp(conn, 404, "not found")
        end
    end

    def put_headers(conn, maps) do
        maps |> Enum.reduce(conn, fn {k, v}, conn ->
            Plug.Conn.put_resp_header(conn, to_string(k), v)
        end)
    end
end