defmodule ConvertWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ConvertWeb, :controller
      use ConvertWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ConvertWeb
      import Plug.Conn
      import ConvertWeb.Router.Helpers
      import ConvertWeb.Gettext

      @doc "Simple API message helper, returns JSON with OK status"
      def ok(msg), do: %{status: :ok, content: msg}

      @doc "Simple API message helper, returns JSON with ERROR status"
      def error(code, reason), do: %{status: :error, content: %{code: code, reason: reason}}
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/convert_web/templates",
        namespace: ConvertWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      import ConvertWeb.Router.Helpers
      import ConvertWeb.ErrorHelpers
      import ConvertWeb.Gettext
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
      import ConvertWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
