defmodule AkediaWeb.Helpers.Auth do
  use Phoenix.Controller, namespace: AkediaWeb
  import Plug.Conn

  def signed_in?(conn) do
    user_id = Plug.Conn.get_session(conn, :user_id)
    if user_id, do: !!Akedia.Repo.get(Akedia.Accounts.User, user_id)
  end

  def check_auth(conn, _args) do
    unless get_session(conn, :user_id) do
      conn
      |> put_flash(:error, "You need to be signed in to do that")
      |> redirect(to: AkediaWeb.Router.Helpers.page_path(conn, :index))
      |> halt()
    else
      conn
    end

    # if user_id = get_session(conn, :user_id) do
    #   current_user = Akedia.Accounts.get_user!(user_id)
    #
    #   conn
    #   |> assign(:current_user, current_user)
    # else
    #   conn
    #   |> put_flash(:error, "You need to be signed in to do that")
    #   |> redirect(to: AkediaWeb.Router.Helpers.page_path(conn, :index))
    #   |> halt()
    # end
  end

  def assign_user(conn, _args) do
    if user_id = get_session(conn, :user_id) do
      current_user = Akedia.Accounts.get_user!(user_id)

      conn
      |> assign(:current_user, current_user)
    else
      conn
    end
  end

end
