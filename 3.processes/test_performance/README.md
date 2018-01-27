- `elixir -r process_chain.ex -e "ProcessesChain.run(100000)"` 运行某ex文件的某方法
- `elixir --erl "+P 1000000" -r process_chain.ex -e "ProcessesChain.run(100000)"` 运行某函数，并制定进程上限

