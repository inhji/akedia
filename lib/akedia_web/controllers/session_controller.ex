defmodule AkediaWeb.SessionController do
  use AkediaWeb, :controller

  alias Akedia.Accounts

  plug :check_auth when action in [:delete]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => auth_params}) do
    with user <- Accounts.get_by_username(auth_params["username"]),
         {:ok, _user} <- Comeonin.Bcrypt.check_pass(user, auth_params["password"]),
         true <- Totpex.validate_totp(user.totp_secret, auth_params["totp"]) do
      conn
      |> put_session(:user_id, user.id)
      |> redirect(to: Routes.admin_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:error, "Login error.")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
