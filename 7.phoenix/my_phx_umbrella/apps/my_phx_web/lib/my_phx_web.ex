defmodule MyPhxWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use MyPhxWeb, :controller
      use MyPhxWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: MyPhxWeb
      import Plug.Conn
      import MyPhxWeb.Router.Helpers
      import MyPhxWeb.Gettext

      def ok(msg), do: %{status: :ok, content: msg}
      def error(code, msg), do: %{status: :error, reason: msg}
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/my_phx_web/templates",
                        namespace: MyPhxWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      import MyPhxWeb.Router.Helpers
      import MyPhxWeb.ErrorHelpers
      import MyPhxWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import MyPhxWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
