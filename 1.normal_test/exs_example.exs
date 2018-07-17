require Logger

libPath = "../../../../../_build/dev/lib/"
File.ls!(libPath) |> Enum.map(&(Code.append_path(libPath<>&1<>"/ebin")))
exsPath = "./exs/"
File.ls!(exsPath) 
|> Enum.filter(&(String.contains?(&1,".exs"))) 
|> Enum.map(&(Code.load_file(exsPath<>&1)))

Application.ensure_all_started(:httpoison)

#CURD
Code.append_path("../../../../../_build/dev/lib/HTTPoison/ebin")
Application.ensure_all_started(:httpoison)
{:ok,_} = HTTPoison.get("www.baidu.com")
Code.load_file("./test.exs")
Test.run()

Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
#{inspect HTTPoison.get(123)}"
try do
    HTTPoison.get(123)
catch
    x->Logger.warn "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
    #{inspect x}"
end

Text.test()

Logger.debug "file: #{inspect Path.basename(__ENV__.file)}  line: #{__ENV__.line}
all ok!"