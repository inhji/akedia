defmodule Akedia.Tracks do
  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Tracks.Track

  def list_tracks() do
    Repo.all(Track)
  end

  def create_track(attrs \\ %{}) do
    %Track{}
    |> Track.changeset(attrs)
    |> Repo.insert()
  end
end
