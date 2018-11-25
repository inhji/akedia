defmodule AkediaWeb.PageController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    posts = Enum.take(Akedia.Posts.list_posts(), 3)

    render(conn, "index.html", posts: posts)
  end

  def now(conn, _params) do
    render(conn, "now.html")
  end
end
