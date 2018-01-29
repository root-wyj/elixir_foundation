defmodule MyGenServer do
  use GenServer

  ##Client API
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  
  #Looks up the bucket pid for \'name\' stored in \'server\'
  #Returns \'{:ok, pid}\' if the bucket exists, \':error\' otherwise.
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end


  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  ##Server Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:lookup, name}, _from, names) do
    {:reply, Map.fetch(names, name), names}
  end

  def handle_cast({:create, name}, names) do
    if (Map.has_key?(names, name)) do
      {:noreply, names}
    else
      {:ok, bucket} = MyGenServer.start_link([])
      {:noreply, Map.put(names, name, bucket)}
    end
  end



end
