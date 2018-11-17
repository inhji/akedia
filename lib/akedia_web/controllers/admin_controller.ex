defmodule AkediaWeb.AdminController do
  use AkediaWeb, :controller

  plug :check_auth
  # Nested Layouts:
  # http://blog.plataformatec.com.br/2018/05/nested-layouts-with-phoenix/
  plug :put_layout, :admin

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
