defmodule Akedia.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :name, :string
      add :caption, :text

      timestamps()
    end

  end
end
