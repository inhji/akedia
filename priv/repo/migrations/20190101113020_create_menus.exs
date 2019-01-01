defmodule Akedia.Repo.Migrations.CreateMenus do
  use Ecto.Migration

  def change do
    create table(:menus) do
      add :name, :string

      timestamps()
    end

  end
end
