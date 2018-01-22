defmodule MyStack do
    use Agent


    

    def peek do
        Agent.start_link(fn -> [] end)
    end

end