defmodule AkediaWeb.FeedController do
  use AkediaWeb, :controller
  alias Atomex.{Feed, Entry}
  alias Akedia.Posts
  alias Akedia.Posts.Post

  defp author, do: "Inhji"
  defp base_url, do: "https://inhji.de/"

  def build_feed(posts) do
    Feed.new(base_url(), DateTime.utc_now(), "Inhji.de Atom Feed")
    |> Feed.author(author(), email: "inhji@posteo.de")
    |> Feed.link("#{base_url()}feed", rel: "self")
    |> Feed.entries(Enum.map(posts, &get_entry/1))
    |> Feed.build()
    |> Atomex.generate_document()
  end

  defp get_entry(%Post{} = post) do
    Entry.new(
      "#{base_url()}posts/#{post.id}",
      DateTime.from_naive!(post.inserted_at, "Etc/UTC"),
      post.excerpt || "Title"
    )
    |> Entry.author(author(), uri: base_url())
    |> Entry.content(post.content_html, type: "html")
    |> Entry.build()
  end

  def index(conn, _params) do
    feed = build_feed(Posts.list_posts())
    html(conn, feed)
  end
end
