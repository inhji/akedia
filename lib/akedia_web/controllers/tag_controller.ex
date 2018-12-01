defmodule AkediaWeb.TagController do
  use AkediaWeb, :controller

  alias Akedia.Tags
  alias Akedia.Tags.Tag

  plug :check_auth when action not in [:show]
  plug :put_layout, :admin when action not in [:show]

  def index(conn, _params) do
    tags = Tags.list_tags()
    render(conn, "index.html", tags: tags)
  end

  def new(conn, _params) do
    changeset = Tags.change_tag(%Tag{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tag" => tag_params}) do
    case Tags.create_tag(tag_params) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "Tag created successfully.")
        |> redirect(to: Routes.tag_path(conn, :show, tag))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"name" => name}) do
    tag = Tags.get_tag_with_posts!(name)

    render(conn, "show.html", tag: tag)
  end

  def edit(conn, %{"name" => name}) do
    tag = Tags.get_tag!(name)
    changeset = Tags.change_tag(tag)
    render(conn, "edit.html", tag: tag, changeset: changeset)
  end

  def update(conn, %{"name" => name, "tag" => tag_params}) do
    tag = Tags.get_tag!(name)

    case Tags.update_tag(tag, tag_params) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "Tag updated successfully.")
        |> redirect(to: Routes.tag_path(conn, :show, tag))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tag: tag, changeset: changeset)
    end
  end

  def delete(conn, %{"name" => name}) do
    tag = Tags.get_tag!(name)
    {:ok, _tag} = Tags.delete_tag(tag)

    conn
    |> put_flash(:info, "Tag deleted successfully.")
    |> redirect(to: Routes.tag_path(conn, :index))
  end
end
