defmodule MyPhxWeb.Router do
  use MyPhxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyPhxWeb do
    pipe_through :api

    get "/hello", HelloController, :hello
    get "/json", HelloController, :test_json
    get "/http", HelloController, :test_http

  end

  scope "/test", MyPhxWeb do
    pipe_through :api
    
    get "/xixi", HelloController, :index

    resources "/users", UserController, only: [:index, :show]

    #forward "/jobs", BackgroundJob.Plug
  end
end
