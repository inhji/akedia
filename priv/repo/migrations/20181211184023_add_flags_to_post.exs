defmodule Akedia.Repo.Migrations.AddFlagsToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :is_page, :boolean
      add :is_deleted, :boolean
    end
  end
end
