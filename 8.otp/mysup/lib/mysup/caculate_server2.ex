defmodule Mysup.CaculateServer2 do
    use GenServer
    require Logger


    @vsn "1"

    defmodule Args do
        defstruct current_number: 0, delta: 1
    end

    def start_link() do
        GenServer.start_link(__MODULE__, Application.get_env(:mysup, :initial_number), name: __MODULE__)

    end

    def increment(delta) do
        GenServer.call(__MODULE__, {:increment, delta})
    end

    def decrement do
        GenServer.call(__MODULE__, :decrement)
    end

    #callback
    def init(init_number) do
        Logger.debug "#{inspect __MODULE__} start"
        case Mysup.Stash.get(__MODULE__) do
            {:ok, value} ->
                Logger.debug "get value from stash. value:#{inspect value}"
                {:ok, %Args{current_number: value}}
            {:error, _} ->
                Logger.debug "get value failed from stash."
                {:ok,  %Args{current_number: init_number}}
        end
    end

    def handle_call({:increment, delta}, _from, state) do
        {
            :reply,
            {:ok, state.current_number+delta},
            %{state | current_number: state.current_number+delta, delta: delta}
        }
    end

    def handle_call(:decrement, _from, state) do
        {
            :reply,
            {:ok, state.current_number-state.delta},
            %{state | current_number: state.current_number - state.delta}
        }
    end

    def terminate(reason, init_number) do
        Logger.info "#{inspect __MODULE__} terminal. reason:#{inspect reason} finally number is #{init_number}"
        Mysup.Stash.save(__MODULE__, init_number)
    end

    def code_change("0", old_state, _extra) do
        Logger.info "Changing code form 0 to 1"
        Logger.info "old state:#{inspect old_state}"
        {:ok, %Args{current_number: old_state, delta: 1}}
    end

    #代码的热替换
    # 首先，需要确定原来代码的版本 如`@vsn "0"` -- 原来版本是
    # 然后编写 和原模块一样名字的模块，如这里的 `Mysup.CaculateServer`，并注意更新版本号
    # 编写好回调 `code_change(old_version, old_state, extra)`
    # 在其运行的虚拟机环境中（这里就是iex）
    #   1. `:sys.suspend Mysup.CaculateServer` 挂起该模块
    #   2. `c "./lib/mysup/caculate_server2.ex"` 重新编译模块的新代码
    #   3. `:sys.change_code Mysup.CaculateServer, Mysup.CaculateServer, "0", []` 告诉虚拟机 该模块代码发生变化
    #   4. `:sys.resume Mysup.CaculateServer` 重新启动该模块
    # 到这里就完成了 不停止服务、不影响数据 的代码更新###
end