defmodule Akedia.Repo.Migrations.AddExcerptToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :excerpt, :text
    end
  end
end
