defmodule Akedia.Menus.Menu do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Menus.Link

  schema "menus" do
    field :name, :string

    has_many :links, Link

    timestamps()
  end

  @doc false
  def changeset(menu, attrs) do
    menu
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
