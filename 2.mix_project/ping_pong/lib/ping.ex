defmodule Ping do


    #spawn(Module, :fn, args:[])

    def start do
        loop()
    end

    def loop do
        #经过测试，该方法启动之后如果没有消息处理，将会阻塞
        #对receive的解释：
        #Processes have a mailbox, and any messages sent to a process queue up in a list
        #in the mailbox. receive will look at the mailbox, and handle the first message
        #it finds in the order specified in the call to receive. If there are no messages,
        #it blocks until there is a message.
        receive do
            {:pong, from} ->
                IO.puts "ping ->"
                :timer.sleep 500
                send(from, {:ping, self()})
            {:ping, from} ->
                IO.puts "        <-pong"
                :timer.sleep 500
                send(from, {:pong, self()})
        end
        
        IO.puts("#self() loop times again")
        loop()
    end
    
end

Agent.up