defmodule AkediaWeb.SessionController do
  use AkediaWeb, :controller

  alias Akedia.Accounts
  alias Akedia.Accounts.User

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
        |> redirect(to: Routes.admin_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Something is terribly wrong with your username/password")
        |> render("new.html")
    end
  end

  def create(conn, %{"session_passwordless" => auth_params}) do
    chat_id = Application.get_env(:akedia, :auth)[:chat_id]
    user = Accounts.get_by_username(auth_params["username"])

    case user do
      nil ->
        conn
        |> put_flash(:info, "nope!")
        |> render("new.html")

      _ ->
        # Nadia.set_webhook(url: "https://1f44ae24.ngrok.io/api/passwordless/hook")
        Nadia.set_webhook(url: "")
        Nadia.send_message(user.chat_id, "You are trying to login, right??")

        conn
        |> put_flash(:info, "yay!!")
        |> render("new.html")
    end
  end

  def hook(conn, %{"message" => message, "update_id" => update_id}) do
    IO.inspect(message)

    chat = Map.get(message, "chat")
    chat_id = Map.get(chat, "id")
    text = Map.get(message, "text")

    case text do
      "Yes" ->
        user = Accounts.get_by_chat_id(chat_id)

        case user do
          nil ->
            IO.puts("No user found")

            conn
            |> render("new.html")

          _ ->
            IO.puts("Success for user #{user.username}!")

            env = Application.get_env(:akedia, AkediaWeb.Endpoint)
            salt = env[:login_token_salt]
            token = Phoenix.Token.sign(conn, salt, user.id)

            IO.puts("Created Token")
            IO.inspect(token)

            Accounts.create_token(%{user_id: user.id, token: token})
            link = "https://1f44ae24.ngrok.io/auth/token?token=" <> token

            Nadia.send_message(
              user.chat_id,
              "Here's your link: #{link}. It's valid for 10 Minutes"
            )

            conn
            |> render("new.html")
        end

      _ ->
        conn
        |> render("new.html")
    end
  end

  def token(conn, %{"token" => login_token}) do
    env = Application.get_env(:akedia, AkediaWeb.Endpoint)
    salt = env[:login_token_salt]

    case Phoenix.Token.verify(conn, salt, login_token, max_age: 600) do
      {:ok, user_id} ->
        token = Accounts.get_token(login_token)
        IO.inspect(token)
        Accounts.delete_token(token)

        conn
        |> put_session(:user_id, user_id)
        |> redirect(to: "/")

      {:error, :expired} ->
        conn
        |> put_flash(:error, "Token expired")
        |> redirect(to: "/")

      {:error, :invalid} ->
        conn
        |> put_flash(:error, "Token not valid")
        |> redirect(to: "/")
    end

    conn
    |> put_flash(:error, "You're in!")
    |> render("new.html")
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out :(")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
