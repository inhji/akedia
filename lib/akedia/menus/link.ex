defmodule Akedia.Menus.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :icon, :string
    field :name, :string
    field :url, :string
    field :menu_id, :id

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:name, :icon, :url])
    |> validate_required([:name, :icon])
  end
end
