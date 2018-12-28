defmodule AkediaWeb.ImageControllerTest do
  use AkediaWeb.ConnCase

  alias Akedia.Images

  @create_attrs %{caption: "some caption", name: "some name"}
  @update_attrs %{caption: "some updated caption", name: "some updated name"}
  @invalid_attrs %{caption: nil, name: nil}

  def fixture(:image) do
    {:ok, image} = Images.create_image(@create_attrs)
    image
  end

  describe "index" do
    test "lists all images", %{conn: conn} do
      conn = get(conn, Routes.image_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Images"
    end
  end

  describe "new image" do
    setup [:create_user]

    test "renders form", %{conn: conn, user: user} do
      conn =
        build_conn()
        |> put_private(:user_id, user.id)
        |> get(Routes.image_path(conn, :new))

      assert html_response(conn, 200) =~ "New Image"
    end

    test "redirects to index when user is not authenticated", %{conn: conn} do
      conn = get(conn, Routes.image_path(conn, :new))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "create image" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.image_path(conn, :create), image: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.image_path(conn, :show, id)

      conn = get(conn, Routes.image_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Image"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.image_path(conn, :create), image: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Image"
    end
  end

  describe "edit image" do
    setup [:create_image, :create_user]

    test "renders form for editing chosen image", %{conn: conn, image: image, user: user} do
      conn =
        build_conn()
        |> put_private(:user_id, user.id)
        |> get(Routes.image_path(conn, :edit, image))

      assert html_response(conn, 200) =~ "Edit Image"
    end

    test "redirects to index when user is not authenticated", %{conn: conn, image: image} do
      conn = get(conn, Routes.image_path(conn, :edit, image))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "update image" do
    setup [:create_image, :create_user]

    test "redirects when data is valid", %{conn: conn, image: image, user: user} do
      conn =
        build_conn()
        |> put_private(:user_id, user.id)
        |> put(Routes.image_path(conn, :update, image), image: @update_attrs)

      assert redirected_to(conn) == Routes.image_path(conn, :show, image)

      conn = get(conn, Routes.image_path(conn, :show, image))
      assert html_response(conn, 200) =~ "some updated caption"
    end

    test "redirects to index when user is not authenticated", %{conn: conn, image: image, user: user} do
      conn = put(conn, Routes.image_path(conn, :update, image), image: @update_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn, image: image, user: user} do
      conn =
        build_conn()
        |> put_private(:user_id, user.id)
        |> put(Routes.image_path(conn, :update, image), image: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Image"
    end
  end

  describe "delete image" do
    setup [:create_image]

    test "deletes chosen image", %{conn: conn, image: image} do
      conn = delete(conn, Routes.image_path(conn, :delete, image))
      assert redirected_to(conn) == Routes.image_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.image_path(conn, :show, image))
      end
    end
  end

  defp create_image(_) do
    image = fixture(:image)
    {:ok, image: image}
  end
end
