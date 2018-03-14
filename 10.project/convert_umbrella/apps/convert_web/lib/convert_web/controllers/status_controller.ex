defmodule ConvertWeb.FileStatus do
  use ConvertWeb, :controller

  require Logger
  import Phoenix.Naming

  def status(conn, %{"id" => id} = params) do
    Logger.debug "params: #{inspect params}"
    case StatusManager.isConverted(params) do
      {:ok, msg} ->
        conn |> json(ok(msg))

      _ ->
        type = params["type"]
        url = params["url"]
        type = if type, do: type, else: "pdf"
        url = if url, do: url, else: "http://221.122.117.73/getpdftestd73b80b7c0890ec.jsp?file=" <> id

        ret = params 
        |> Map.put("type", type)
        |> Map.put("url", url)
        |> ConvertManager.start_work

        conn |> json(error(402, "没转好"))
        
    end
  end

  def queue_size(conn, %{}=params) do
    type = params["type"]
    type = if type, do: type, else: "pdf"

    case type do
      "pdf" ->
        {:ok, count} = ConvertQueue.pdf_queue_size()
        conn |> json(ok(%{count: count}))
      _ ->
        conn |> json(error(420, "unsupport type"))
    end
  end

  def convert_data(conn, %{}=params) do
    conn |> json(ok(LogManager.get({:all_data})))
  end

  def test(conn, %{}) do
    conn |> json(error(420, "success"))
  end
end
