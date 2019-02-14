defmodule AkediaWeb.Plugs.CheckUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Akedia.Accounts
  alias AkediaWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  def call(conn, _opts) do
    user_exists = Accounts.count_users() != 0
    not_on_register = conn.request_path != Routes.user_path(conn, :new)

    if not user_exists and not_on_register do
      conn
      |> redirect(to: Routes.user_path(conn, :new))
    else
      conn
    end
  end
end
