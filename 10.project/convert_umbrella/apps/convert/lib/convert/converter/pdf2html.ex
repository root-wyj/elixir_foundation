defmodule Convert.PDF2HTML do
  require Logger

  def convert_all(%{type: "pdf"}=msg) do

    Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
    pdf2html: #{inspect(msg)} start")
    {:ok, filePath} = downloadFile_(msg.id, msg.url)
    work_dir = Application.get_env(:convert, :file_convert_dir)
    destPath = Path.join(work_dir, Path.basename(filePath, ".pdf"))
    tempPath = Path.join(destPath, "tmp")
    
    opts = []
    # 1 
    # opts = ["--only-process-font", 1 | opts]
    # 转哪一页
    # opts = ["--page-index", index | opts]

    opts = ["--tmp-dir", tempPath | opts]
    opts = ["--dest-dir", destPath | opts]
    opts = [filePath | opts]

    convert_(opts, filePath, 100)
    # Process.sleep 10000

    Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
    pdf2html: #{inspect(msg)} end")
    {:ok, %{}}
  end

  def convert_pre(%{type: "pdf"}=msg) do
    
    Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
    pdf2html: #{inspect(msg)} start")
    {:ok, filePath} = downloadFile_(msg.id, msg.url)
    work_dir = Application.get_env(:convert, :file_convert_dir)
    destPath = Path.join(work_dir, Path.basename(filePath, ".pdf"))
    tempPath = Path.join(destPath, "tmp")
        
    opts = []
    opts = ["--only-process-font", "1" | opts]
    opts = ["--tmp-dir", tempPath | opts]
    opts = ["--dest-dir", destPath | opts]
    opts = [filePath | opts]
    
    time_start = DateTime.utc_now
    convert_(opts, filePath, 100)
    time_end = DateTime.utc_now

    #获取file基本信息
    {:ok, file_stat} = File.stat(filePath)

    #获取页数
    {:ok, data} = File.read(Path.join(destPath, "meta.json"))
    {:ok, %{"page_count" => page_count}} = Poison.Parser.parse(data)

    LogManager.log({:doc_base, %{id: msg.id, file_size: (Map.get(file_stat, :size) |> div(1024) |> Integer.to_string()) <> "K", page_count: page_count}})

    LogManager.log({:doc_font, %{id: msg.id, font_time: DateTime.diff(time_end, time_start, :millisecond)}})
    
    Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
    pdf2html: #{inspect(msg)} end")
    {:ok, %{}}
  end

  def convert_page(%{type: "pdf"}=msg) do
    
    Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
    pdf2html: #{inspect(msg)} start")
    filePath = Path.join(Application.get_env(:convert, :file_download_dir), msg.id<>".pdf")
    work_dir = Application.get_env(:convert, :file_convert_dir)
    destPath = Path.join(work_dir, Path.basename(filePath, ".pdf"))
    tempPath = Path.join(destPath, "tmp")

    page_file_path = work_dir
    |> Path.join msg.id
    |> Path.join msg.page
    if (File.exists? page_file_path) do
      {:ok, %{}}
    else
      opts = []
      opts = ["--only-process-font", "0" | opts]
      opts = ["--page-index", msg.page | opts]
      opts = ["--tmp-dir", tempPath | opts]
      opts = ["--dest-dir", destPath | opts]
      opts = [filePath | opts]
      Logger.debug "opts:#{inspect opts}"
      time_start = DateTime.utc_now
      convert_(opts, filePath, 100)
      time_end = DateTime.utc_now
      LogManager.log({:doc_page, %{id: msg.id, pages: %{msg.page => DateTime.diff(time_end, time_start, :millisecond)}}})
      
      Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
      pdf2html: #{inspect(msg)} end")
      {:ok, %{}}
    end
    
  end

  defp downloadFile_(id, url) do
    Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
        download: #{inspect(id)} start")
    time_start = DateTime.utc_now;
    user = %{filename: id <> ".pdf", dirname: Application.get_env(:convert, :file_download_dir)}
    {:ok, _} = Avatar.FileDownload.store({url, user})
    time_end = DateTime.utc_now
    LogManager.log({:download_time, %{id: id, download_time: DateTime.diff(time_end, time_start, :millisecond)}})
    Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
        download: #{inspect(id)} end")
    {:ok, Path.join(user.dirname, user.filename)}
  end

  defp convert_(opts, filePath, 0) do
    {:error, %{reason: "失败次数过多"}}
  end

  defp convert_(opts, filePath, count) do
    Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
        convert #{inspect(filePath)} start")

    cmd = "pdf2htmlEX"

    {msg, exit_status} = System.cmd(cmd, opts, stderr_to_stdout: false)

    Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
    convert #{inspect(filePath)} end")
    Logger.debug("exec result. msg:#{inspect(msg)}, exit_status:#{inspect(exit_status)}")

    case exit_status do
      0 ->
        {:ok, %{}}
        
      _ ->
        convert_(opts, filePath, count-1)
    end
  end

end
