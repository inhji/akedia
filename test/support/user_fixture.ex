defmodule Akedia.UserFixture do
  alias Akedia.Accounts

  @create_attrs %{encrypted_password: "some encrypted_password", username: "some username"}

  def user_fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  def create_user(_) do
    user = user_fixture(:user)
    {:ok, user: user}
  end
end
