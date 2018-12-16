defmodule Akedia.Tracks.Track do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tracks" do
    field :name, :string
    field :artist, :string
    field :album, :string
    field :timestamp, :integer
    field :listened_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [:name, :artist, :album, :timestamp, :listened_at])
    |> validate_required([:name, :artist, :album, :timestamp, :listened_at])
    |> unique_constraint(:listened_at)
  end
end
