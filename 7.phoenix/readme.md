# Phoenix

## 常用指令
- `mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez` 安装Phoenix
- `mix phx.new xx_xx` 创建一个新项目，通常创建一个单纯的服务项目用`mix phx.new hello_world --umbrella --no-brunch --no-ecto --no-html`
- `mix phx.server` | `iex -S mix phx.server` 启动该项目，默认端口号4000
- `mix phx.routes` 查看所有的路径映射关系（进入 app_web 目录）
- `mix deps.get` 获取依赖
- `mix deps.compile` 编译依赖
- `mix compile` 编译
- `MIX_ENV=prod mix phx.server` 以开发环境启动

> **Phoenix v1.3.1 有一个bug，需要修改源码 phoenix/lib/phoenix/code_reloader.server.ex 27行 修改如下 `if not checked? and Code.ensure_loaded?(Mix.Project) and not Mix.Project.umbrella? do`**
