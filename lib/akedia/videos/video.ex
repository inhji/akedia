defmodule Akedia.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset


  schema "videos" do
    field :caption, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:name, :caption])
    |> validate_required([:name, :caption])
  end
end
