defmodule AkediaWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use AkediaWeb, :controller
      use AkediaWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: AkediaWeb

      import Plug.Conn
      import AkediaWeb.Gettext
      import AkediaWeb.Helpers.Auth, only: [check_auth: 2, can_register?: 2]

      alias AkediaWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/akedia_web/templates",
        namespace: AkediaWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]
      import PhoenixActiveLink

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import AkediaWeb.ErrorHelpers
      import AkediaWeb.Gettext
      import AkediaWeb.Helpers.Auth, only: [signed_in?: 1]

      import AkediaWeb.Helpers.Content,
        only: [
          image_url: 1,
          image_url: 2,
          tags_as_string: 1,
          from_now_link: 1,
          from_now: 1,
          iso_date: 1
        ]

      import AkediaWeb.Helpers.Input
      alias AkediaWeb.Router.Helpers, as: Routes
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
      import AkediaWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
