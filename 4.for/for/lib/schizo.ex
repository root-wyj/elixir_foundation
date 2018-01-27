defmodule Schizo do
    # 最开始的写法
    def uppercase2(string) do
        string
          |> String.split(" ")
          |> Enum.with_index
          |> Enum.map(&String.upcase(&1))
          |> Enum.join(" ")
    end

    #改变 拆分之后的写法
    def uppercase(string) do
        every_word(string, fn word -> String.upcase(word) end)
    end

    def every_word(string, fun) do
        string
          |> String.split(" ")
          |> Enum.with_index
          |> Enum.map(fn ({word, index}) -> 
            if rem(index, 2) == 0 do 
                word
            else
                fun.(word)
            end
          end)
          |> Enum.join(" ")
          
    end

    def unvowel (string) do
        every_word(string, fn word -> Regex.replace(~r/[aeiou]/, word, "") end)
    end
end