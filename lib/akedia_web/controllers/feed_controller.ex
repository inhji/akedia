defmodule AkediaWeb.FeedController do
  use AkediaWeb, :controller
  alias Atomex.{Feed, Entry}
  alias Akedia.Posts
  alias Akedia.Posts.Post

  defp author, do: "Inhji"

  def build_feed(conn, posts) do
    base_url = Routes.page_url(conn, :index)

    Feed.new(base_url, DateTime.utc_now(), "Inhji.de Atom Feed")
    |> Feed.logo(Routes.static_path(conn, "/images/logo.png"))
    |> Feed.author(author(), email: "inhji@posteo.de")
    |> Feed.link(Routes.feed_url(conn, :index), rel: "self")
    |> Feed.entries(
      Enum.map(posts, fn %Post{} = post ->
        Entry.new(
          Routes.post_url(conn, :show, post.id),
          DateTime.from_naive!(post.inserted_at, "Etc/UTC"),
          post.excerpt || "Title"
        )
        |> Entry.link(Routes.post_url(conn, :show, post.id))
        |> Entry.author(author(), uri: base_url)
        |> Entry.content(post.content_html, type: "html")
        |> Entry.build()
      end)
    )
    |> Feed.build()
    |> Atomex.generate_document()
  end

  def index(conn, _params) do
    feed = build_feed(conn, Posts.list_posts())
    html(conn, feed)
  end
end
