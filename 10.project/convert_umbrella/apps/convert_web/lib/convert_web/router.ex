defmodule ConvertWeb.Router do
  use ConvertWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  get("/hello", ConvertWeb.HelloController, :hello)

  get("/node_test", ConvertWeb.HelloController, :node_test);

  scope "/api", ConvertWeb do
    pipe_through(:api)

    get("/convert_status", FileStatus, :status)

    get("/test", FileStatus, :test)

    get("/queue_size", FileStatus, :queue_size)

    get("/:id/page/:page", PageController, :get_page)

    get("/:id/font/:font", PageController, :get_font)

    get("/convert_data", FileStatus, :convert_data)
  end

end
