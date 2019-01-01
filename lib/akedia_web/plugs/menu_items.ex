defmodule AkediaWeb.Plugs.MenuItems do
  import Plug.Conn

  alias Akedia.Menus

  def init(menu_name), do: menu_name

  def call(conn, menu_name) when is_binary(menu_name) do
    conn
    |> assign_menu(menu_name, get_links(menu_name))
  end

  def call(conn, menu_names) when is_list(menu_names) do
    menu_names
    |> Enum.reduce(conn, &assign_menus/2)
  end

  def get_links(menu_name) do
    case menu = Menus.get_menu_by_name(menu_name) do
      nil -> nil
      _ -> menu.links
    end
  end

  def assign_menus(name, conn), do: assign_menu(conn, name, get_links(name))

  def assign_menu(conn, menu_name, links) do
    existing_menus = conn.assigns[:menus] || %{}
    name_atom = String.to_atom(menu_name)

    conn
    |> assign(:menus, Map.put(existing_menus, name_atom, links))
  end
end
