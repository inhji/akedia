defmodule AkediaWeb.FeedController do
  use AkediaWeb, :controller
  alias Atomex.{Feed, Entry}
  alias Akedia.Posts
  alias Akedia.Posts.Post

  def index(conn, _params) do
    feed = build_feed(conn, Posts.list_posts(["note", "article"]))

    conn
    |> put_resp_content_type("application/atom+xml")
    |> html(feed)
  end

  defp build_feed(conn, posts) do
    base_url = Routes.post_url(conn, :index)
    hub_url = Application.get_env(:akedia, :indie)[:websub_hub]

    Feed.new(base_url, DateTime.utc_now(), "Inhji.de Atom Feed")
    |> Feed.logo(Routes.static_path(conn, "/images/logo.png"))
    |> Feed.author("Jonathan Jenne", email: "inhji@posteo.de")
    |> Feed.link(Routes.feed_url(conn, :index), rel: "self")
    |> Feed.link(hub_url, rel: "hub")
    |> Feed.entries(
      Enum.map(posts, fn %Post{} = post ->
        Entry.new(
          Routes.post_url(conn, :show, post.id),
          DateTime.from_naive!(post.inserted_at, "Etc/UTC"),
          post.title || post.content || "Title"
        )
        |> Entry.link(Routes.post_url(conn, :show, post.id))
        |> Entry.author("Jonathan Jenne", uri: base_url)
        |> Entry.content(post.content_html, type: "html")
        |> Entry.build()
      end)
    )
    |> Feed.build()
    |> Atomex.generate_document()
  end
end
