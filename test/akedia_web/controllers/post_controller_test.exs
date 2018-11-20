defmodule AkediaWeb.PostControllerTest do
  use AkediaWeb.ConnCase

  alias Akedia.Posts

  @create_attrs %{content: "some content"}
  @update_attrs %{content: "some updated content"}
  @invalid_attrs %{content: nil}

  def fixture(:post) do
    {:ok, post} = Posts.create_post(@create_attrs)
    post
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert html_response(conn, 200) =~ "posts"
      assert true
    end
  end

  describe "new post" do
    setup [:create_user]

    test "renders form", %{conn: conn, user: user} do
      conn =
        build_conn()
        |> put_private(:user_id, user.id)
        |> get(Routes.post_path(conn, :new))

      assert html_response(conn, 200) =~ "compose an epic"
    end

    test "redirects to index when user is not authenticated", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :new))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "create post" do
    setup [:create_user]

    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn =
        build_conn()
        |> put_private(:user_id, user.id)
        |> post(Routes.post_path(conn, :create), post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "some content"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn =
        build_conn()
        |> put_private(:user_id, user.id)
        |> post(Routes.post_path(conn, :create), post: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Post"
    end

    test "redirects to index when user is not authenticated", %{conn: conn} do
      conn = post(conn, Routes.post_path(conn, :create), post: @create_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "edit post" do
    setup [:create_post, :create_user]

    test "renders form for editing chosen post", %{conn: conn, post: post, user: user} do
      conn =
        build_conn()
        |> put_private(:user_id, user.id)
        |> get(Routes.post_path(conn, :edit, post))

      assert html_response(conn, 200) =~ "Edit Post"
    end

    test "redirects to index when user is not authenticated", %{conn: conn, post: post} do
      conn = get(conn, Routes.post_path(conn, :edit, post))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "update post" do
    setup [:create_post, :create_user]

    test "redirects when data is valid", %{conn: conn, post: post, user: user} do
      conn =
        build_conn()
        |> put_private(:user_id, user.id)
        |> put(Routes.post_path(conn, :update, post), post: @update_attrs)

      assert redirected_to(conn) == Routes.post_path(conn, :show, post)

      conn = get(conn, Routes.post_path(conn, :show, post))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post, user: user} do
      conn =
        build_conn()
        |> put_private(:user_id, user.id)
        |> put(Routes.post_path(conn, :update, post), post: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Post"
    end

    test "redirects to index when user is not authenticated", %{conn: conn, post: post} do
      conn = put(conn, Routes.post_path(conn, :update, post), post: @invalid_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  describe "delete post" do
    setup [:create_post, :create_user]

    test "deletes chosen post", %{conn: conn, post: post, user: user} do
      conn =
        build_conn()
        |> put_private(:user_id, user.id)
        |> delete(Routes.post_path(conn, :delete, post))

      assert redirected_to(conn) == Routes.post_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end

    test "redirects to index when user is not authenticated", %{conn: conn, post: post} do
      conn = delete(conn, Routes.post_path(conn, :delete, post))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    {:ok, post: post}
  end
end
