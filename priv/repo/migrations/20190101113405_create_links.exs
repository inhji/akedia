defmodule Akedia.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :name, :string
      add :icon, :string
      add :url, :string  

      timestamps()
    end
  end
end
