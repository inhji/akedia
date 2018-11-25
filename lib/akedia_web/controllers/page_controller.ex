defmodule AkediaWeb.PageController do
  use AkediaWeb, :controller
  alias Akedia.Posts

  def index(conn, params) do
    page = Posts.list_posts_paginated(params)

    render(conn, "index.html", page: page, posts: page.entries)
  end

  def now(conn, _params) do
    render(conn, "now.html")
  end
end
