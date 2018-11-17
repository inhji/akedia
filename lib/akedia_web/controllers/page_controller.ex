defmodule AkediaWeb.PageController do
  use AkediaWeb, :controller

  plug :put_layout, :public when action in [:index]

  def index(conn, _params) do
    posts = Enum.take(Akedia.Posts.list_posts(), 3)

    render(conn, "index.html", posts: posts)
  end
end
