defmodule Akedia.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :name, :string
      add :caption, :text

      timestamps()
    end

  end
end
