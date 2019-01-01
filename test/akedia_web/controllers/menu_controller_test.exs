defmodule AkediaWeb.MenuControllerTest do
  use AkediaWeb.ConnCase

  alias Akedia.Menus

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:menu) do
    {:ok, menu} = Menus.create_menu(@create_attrs)
    menu
  end

  describe "index" do
    test "lists all menus", %{conn: conn} do
      conn = get(conn, Routes.menu_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Menus"
    end
  end

  describe "new menu" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.menu_path(conn, :new))
      assert html_response(conn, 200) =~ "New Menu"
    end
  end

  describe "create menu" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.menu_path(conn, :create), menu: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.menu_path(conn, :show, id)

      conn = get(conn, Routes.menu_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Menu"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.menu_path(conn, :create), menu: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Menu"
    end
  end

  describe "edit menu" do
    setup [:create_menu]

    test "renders form for editing chosen menu", %{conn: conn, menu: menu} do
      conn = get(conn, Routes.menu_path(conn, :edit, menu))
      assert html_response(conn, 200) =~ "Edit Menu"
    end
  end

  describe "update menu" do
    setup [:create_menu]

    test "redirects when data is valid", %{conn: conn, menu: menu} do
      conn = put(conn, Routes.menu_path(conn, :update, menu), menu: @update_attrs)
      assert redirected_to(conn) == Routes.menu_path(conn, :show, menu)

      conn = get(conn, Routes.menu_path(conn, :show, menu))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, menu: menu} do
      conn = put(conn, Routes.menu_path(conn, :update, menu), menu: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Menu"
    end
  end

  describe "delete menu" do
    setup [:create_menu]

    test "deletes chosen menu", %{conn: conn, menu: menu} do
      conn = delete(conn, Routes.menu_path(conn, :delete, menu))
      assert redirected_to(conn) == Routes.menu_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.menu_path(conn, :show, menu))
      end
    end
  end

  defp create_menu(_) do
    menu = fixture(:menu)
    {:ok, menu: menu}
  end
end
