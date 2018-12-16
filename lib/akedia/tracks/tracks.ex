defmodule Akedia.Tracks do
  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Tracks.Track

  def list_tracks() do
    Repo.all(Track)
  end

  def list_tracks_for(:today, limit \\ 10) do
    query = tracks_for(get_today())

    Repo.all(
      from(t in query,
        order_by: [desc: :listened_at],
        limit: ^limit
      )
    )
  end

  def list_artists_for(:today) do
    query = tracks_for(get_today())

    Repo.all(
      from(t in query,
        group_by: t.artist,
        select: {t.artist, count(t.id)}
      )
    )
  end

  def tracks_for(day) do
    from(t in Track,
      where: t.listened_at >= ^Timex.beginning_of_day(day),
      where: t.listened_at < ^Timex.end_of_day(day)
    )
  end

  defp get_today() do
    Date.utc_today()
    |> Timex.to_datetime()
  end

  def create_track(attrs \\ %{}) do
    %Track{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end
end
