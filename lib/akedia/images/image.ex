defmodule Akedia.Images.Image do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :caption, :string
    field :name, Akedia.Images.ImageUploader.Type

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:caption])
    |> validate_required([:caption])
  end

  def image_changeset(image, attrs) do
    image
    |> cast_attachments(attrs, [:name])
  end
end
