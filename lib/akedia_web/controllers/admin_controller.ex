defmodule AkediaWeb.AdminController do
  use AkediaWeb, :controller
  alias Akedia.Posts
  alias Akedia.Tags

  plug :check_auth
  # Nested Layouts:
  # http://blog.plataformatec.com.br/2018/05/nested-layouts-with-phoenix/
  plug :put_layout, :admin

  def index(conn, _params) do
    posts_count = Posts.count_posts()
    tags_count = Tags.count_tags()

    notes_count = Posts.count_posts("note")
    replies_count = Posts.count_posts("reply")
    bookmarks_count = Posts.count_posts("bookmark")
    likes_count = Posts.count_posts("like")
    articles_count = Posts.count_posts("article")

    render(conn, "index.html",
      posts: posts_count,
      tags: tags_count,
      notes: notes_count,
      replies: replies_count,
      bookmarks: bookmarks_count,
      likes: likes_count,
      articles: articles_count
    )
  end
end
