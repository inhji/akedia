defmodule AkediaWeb.SessionController do
  use AkediaWeb, :controller

  alias Akedia.Accounts

  plug :check_auth when action in [:delete]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => auth_params}) do
    user = Accounts.get_by_username(auth_params["username"])

    case Comeonin.Bcrypt.check_pass(user, auth_params["password"]) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "A good day to you, Sir #{user.username}! o\/")
        |> redirect(to: Routes.admin_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Something is terribly wrong with your username/password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out :(")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
