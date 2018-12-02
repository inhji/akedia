defmodule AkediaWeb.PageController do
  use AkediaWeb, :controller
  alias Akedia.Posts

  @index_types ["note", "bookmark", "reply", "repost"]
  @allowed_types ["note", "bookmark", "reply", "repost", "like"]

  def index(conn, params) do
    page = Posts.list_posts_paginated(params, @index_types)

    render(conn, "index.html", page: page, posts: page.entries)
  end

  def type(conn, %{"type" => post_type} = params) do
    if Enum.member?(@allowed_types, post_type) do
      page = Posts.list_posts_paginated(params, [post_type])

      render(conn, "posts.html",
        page: page,
        posts: page.entries,
        title: "Posts of type #{String.capitalize(post_type)}"
      )
    else
      redirect(conn, to: Routes.page_path(conn, :index))
    end
  end

  def now(conn, _params) do
    render(conn, "now.html")
  end
end
