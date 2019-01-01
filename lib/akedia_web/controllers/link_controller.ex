defmodule AkediaWeb.LinkController do
  use AkediaWeb, :controller

  alias Akedia.Menus
  alias Akedia.Menus.Link

  plug :check_auth
  plug :put_layout, :admin

  def new(conn, _params) do
    changeset = Menus.change_link(%Link{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"link" => link_params, "menu_id" => menu_id}) do
    menu = Menus.get_menu!(menu_id)

    link_changeset =
      Ecto.build_assoc(menu, :links,
        url: link_params["url"],
        name: link_params["name"],
        icon: link_params["icon"]
      )

    case Akedia.Repo.insert(link_changeset) do
      {:ok, _link} ->
        conn
        |> put_flash(:info, "Link created successfully.")
        |> redirect(to: Routes.menu_path(conn, :show, menu))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id, "menu_id" => menu_id}) do
    link = Menus.get_link!(id)
    render(conn, "show.html", link: link, menu_id: menu_id)
  end

  def edit(conn, %{"id" => id, "menu_id" => menu_id}) do
    link = Menus.get_link!(id)
    changeset = Menus.change_link(link)
    render(conn, "edit.html", link: link, changeset: changeset, menu_id: menu_id)
  end

  def update(conn, %{"id" => id, "menu_id" => menu_id, "link" => link_params}) do
    link = Menus.get_link!(id)

    case Menus.update_link(link, link_params) do
      {:ok, _link} ->
        conn
        |> put_flash(:info, "Link updated successfully.")
        |> redirect(to: Routes.menu_path(conn, :show, menu_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", link: link, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "menu_id" => menu_id}) do
    link = Menus.get_link!(id)
    {:ok, _link} = Menus.delete_link(link)

    conn
    |> put_flash(:info, "Link deleted successfully.")
    |> redirect(to: Routes.menu_path(conn, :show, menu_id))
  end
end
