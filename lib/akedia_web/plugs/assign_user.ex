defmodule AkediaWeb.Plugs.AssignUser do
  import Plug.Conn

  alias Akedia.Accounts
  alias AkediaWeb.Helpers.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn |> Auth.get_user_id() do
      nil ->
        conn

      user_id ->
        conn
        |> assign(:current_user, get_user(conn, user_id))
    end
  end

  def get_user(conn, id) do
    case conn.assigns[:current_user] do
      nil -> Accounts.get_user!(id)
      user -> user
    end
  end
end
