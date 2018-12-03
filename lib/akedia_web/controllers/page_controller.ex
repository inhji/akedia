defmodule AkediaWeb.PageController do
  use AkediaWeb, :controller

  def now(conn, _params) do
    render(conn, "now.html")
  end
end
