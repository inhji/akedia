defmodule AkediaWeb.Helpers.Auth do
  use Phoenix.Controller, namespace: AkediaWeb
  alias AkediaWeb.Router.Helpers, as: Routes
  alias Akedia.Accounts
  import Plug.Conn

  def signed_in?(conn) do
    !!get_user_id(conn)
  end

  def can_register?(conn, _args) do
    case Accounts.count_users() do
      0 -> conn
      _ -> serious_error!(conn, "Sry, u can't register :/")
    end
  end

  def check_auth(conn, _args) do
    case get_user_id(conn) do
      nil -> serious_error!(conn, "You need to be signed in to do that")
      _ -> conn
    end
  end

  def get_user_id(conn) do
    case Mix.env() do
      :test -> conn.private[:user_id]
      _ -> get_session(conn, :user_id)
    end
  end

  defp serious_error!(conn, message) do
    conn
    |> put_flash(:error, message)
    |> redirect(to: Routes.post_path(conn, :index))
    |> halt()
  end
end
