defmodule Convert.WORD2PDF do

    require Logger


    def convert(%{type: "doc"} = params) do
        _convert(params)
    end

    def convert(%{type: "docx"} = params) do
        _convert(params)
    end

    defp _convert(%{type: type, id: id, url: url} = params) do
        Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
        word2pdf: #{inspect(params)} start")

        {:ok, filepath} = download(id, url, type);
        work_dir = Application.get_env(:convert, :file_convert_dir)
        source_path = filepath
        target_path = String.replace(filepath, "."<>type, ".pdf")
        
        Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
        word2pdf: #{inspect(params)} end")

        {:ok, _} = convert_word(source_path, target_path, 100);

        {:ok, target_path}

        # stream = File.stream!(source_path)


        # stream
        # |> Stream.into(File.stream!(target_path))
        # |> Stream.run
    end

    defp download(id, url, type) do
        Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
        download: #{inspect(id)} start")
        user = %{filename: id <> "." <> type, dirname: Application.get_env(:convert, :file_download_dir)}
        {:ok, _} = Avatar.FileDownload.store({url, user})
        Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
        download: #{inspect(id)} end")
        {:ok, Path.join(user.dirname, user.filename)} 
    end


    defp convert_word(source_path, target_path, 0) do
        {:error, %{reason: "失败次数过多"}}
    end

    defp convert_word(source_path, target_path, count) do
        Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
        convert #{inspect(source_path)} start")

        cmd = "D:\\wuyingjie\\pdf2html\\pc-web\\convertWord\\word2pdf\\word2pdf.exe"
        opts = [source_path, target_path]

        {msg, exit_status} = System.cmd(cmd, opts, stderr_to_stdout: false)

        Logger.debug("file: #{inspect(Path.basename(__ENV__.file))}  line: #{__ENV__.line}
        convert #{inspect(source_path)} end")

        Logger.debug("exec result. msg:#{inspect(msg)}, exit_status:#{inspect(exit_status)}")
        case exit_status do
            0 ->
                {:ok, %{}}
            _ ->
                convert_word(source_path, target_path, count-1)
        end
    end

end