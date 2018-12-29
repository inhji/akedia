defmodule Akedia.UserFixture do
  alias Akedia.Accounts
  import Plug.Conn

  @create_attrs %{encrypted_password: "some encrypted_password", username: "some username"}

  def user_fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  def create_user(%{:conn => conn} = args) do
    user = user_fixture(:user)
    conn = conn
    |> put_private(:user_id, user.id)

    {:ok, conn: conn, user: user}
  end
end
