defmodule AkediaWeb.PostController do
  use AkediaWeb, :controller

  alias Akedia.Repo
  alias Akedia.Posts
  alias Akedia.Posts.Post
  alias AkediaWeb.Helpers.Webmentions

  plug :check_auth when action in [:new, :create, :edit, :update, :delete]
  plug :put_layout, :admin when action in [:new, :create, :edit, :update, :delete]

  def index(conn, params) do
    page = Posts.list_posts_paginated(params)

    render(
      conn,
      "index.html",
      page: page,
      posts: page.entries
    )
  end

  def new(conn, _params) do
    changeset =
      %Post{}
      |> Repo.preload(:tags)
      |> Posts.change_post()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Posts.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(
          :info,
          Webmentions.send_webmentions(Routes.post_url(conn, :show, post), "Post", "created")
        )
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
    tags = Enum.map(post.tags, fn t -> t.name end)

    changeset = Posts.change_post(post)

    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(
          :info,
          Webmentions.send_webmentions(Routes.post_url(conn, :show, post), "Post", "created")
        )
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
