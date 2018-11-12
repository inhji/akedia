defmodule Akedia.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :content, :string, size: 5000

      timestamps()
    end

  end
end
