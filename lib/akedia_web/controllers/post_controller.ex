defmodule AkediaWeb.PostController do
  use AkediaWeb, :controller

  alias Akedia.Repo
  alias Akedia.Posts
  alias Akedia.Posts.Post
  alias AkediaWeb.Helpers.Webmentions

  plug :check_auth when action in [:new, :create, :edit, :update, :delete]
  plug :put_layout, :admin when action in [:new, :create, :edit, :update, :delete]

  @index_types ["note", "bookmark", "reply", "repost"]
  @allowed_types ["note", "bookmark", "reply", "repost", "like", "article"]

  def index_all(conn, params) do
    page = Posts.list_posts_paginated(params)

    render(
      conn,
      "index.html",
      page: page,
      posts: page.entries
    )
  end

  def index(conn, params) do
    page = Posts.list_posts_paginated(params, @index_types)

    render(conn, "index.html", page: page, posts: page.entries)
  end

  def by_type(conn, %{"type" => post_type} = params) do
    if Enum.member?(@allowed_types, post_type) do
      page = Posts.list_posts_paginated(params, [post_type])
      count = Posts.count_posts(post_type)

      render(conn, "index_by_type.html",
        page: page,
        posts: page.entries,
        count: count,
        type: String.capitalize(post_type)
      )
    else
      redirect(conn, to: Routes.page_path(conn, :index))
    end
  end

  def new(conn, %{"type" => post_type}) do
    changeset =
      %Post{}
      |> Repo.preload(:tags)
      |> Posts.change_post()

    render(conn, "new.html", changeset: changeset, type: post_type)
  end

  def new(conn, _) do
    redirect(conn, to: Routes.post_path(conn, :new, type: "note"))
  end

  def create(conn, %{"post" => post_params}) do
    case Posts.create_post(post_params) do
      {:ok, post} ->
        url = Routes.post_url(conn, :show, post)
        message = Webmentions.send_webmentions(url, "Post", "created")

        conn
        |> put_flash(:info, message)
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Posts.get_post!(id)

    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    changeset = Posts.change_post(post)

    render(conn, "edit.html", post: post, changeset: changeset, type: post.type)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        url = Routes.post_url(conn, :show, post)
        message = Webmentions.send_webmentions(url, "Post", "updated")

        conn
        |> put_flash(:info, message)
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
