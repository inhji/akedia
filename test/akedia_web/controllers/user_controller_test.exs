defmodule AkediaWeb.UserControllerTest do
  use AkediaWeb.ConnCase

  @create_attrs %{encrypted_password: "some encrypted_password", username: "some username"}
  @update_attrs %{
    encrypted_password: "some updated encrypted_password",
    username: "some updated username"
  }
  @invalid_attrs %{encrypted_password: nil, username: nil}

  describe "new user" do
    setup [:create_user]

    test "prevents another user from registering when one user exists", %{conn: conn} do
      conn =
        conn
        |> fetch_flash
        |> get(Routes.user_path(conn, :new))

      assert get_flash(conn, :error) == "Sry, u can't register :/"
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "create user" do
    setup [:create_user]

    test "prevents another user from registering when one user exists", %{conn: conn} do
      conn =
        conn
        |> fetch_flash
        |> post(Routes.user_path(conn, :create), user: @create_attrs)

      assert get_flash(conn, :error) == "Sry, u can't register :/"
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, Routes.user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{conn: conn, user: user} do
      result_conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(result_conn) == Routes.user_path(result_conn, :show, user)

      result_conn = get(conn, Routes.user_path(conn, :show, user))
      assert html_response(result_conn, 200) =~ "some updated username"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end
end
