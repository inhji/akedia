defmodule AkediaWeb.PageController do
  use AkediaWeb, :controller
  alias Akedia.Tracks

  def now(conn, _params) do
    tracks = Tracks.list_tracks_for(:today)

    artists =
      Tracks.list_artists_for(:today)
      |> Enum.sort_by(fn {_, count} -> count end, &>/2)

    IO.inspect(artists)

    render(conn, "now.html", tracks: tracks, artists: artists)
  end
end
