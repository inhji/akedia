defmodule AkediaWeb.PageController do
  use AkediaWeb, :controller
  alias Akedia.Tracks
  alias Akedia.Posts
  alias Akedia.Images

  def index(conn, _params) do
    note = List.first(Posts.last_posts("note"))
    bookmarks = Posts.last_posts("bookmark", 3)
    articles = Posts.last_posts("article", 3)
    track = Tracks.last_track()
    photos = Images.list_images(4)

    render(
      conn,
      "index.html",
      note: note,
      track: track,
      bookmarks: bookmarks,
      articles: articles,
      photos: photos
    )
  end

  def now(conn, _params) do
    tracks = Tracks.list_tracks_for(:today)

    artists =
      Tracks.list_artists_for(:today)
      |> Enum.sort_by(fn {_, count} -> count end, &>/2)

    render(conn, "now.html", tracks: tracks, artists: artists)
  end
end
