defmodule Akedia.Repo.Migrations.AddImageToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :image, :text
    end
  end
end
