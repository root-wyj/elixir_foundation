defmodule WyjTest do
    use ExUnit.Case

    setup do
        # {:ok, pid} = start_supervised(ConvertQueue)
        pid = spawn(ConvertQueue, :start_link, [])
        IO.puts "init #{inspect pid}"
        %{queue_pid: pid}
    end

    test "test convert_queue", %{queue_pid: pid} do
        assert true == Process.exit(pid, :kill)
    end

    test "test read file" do
        result = File.read("C:\\Users\\Administrator\\Desktop\\id.txt")
        IO.puts "#{inspect result}"
    end

end