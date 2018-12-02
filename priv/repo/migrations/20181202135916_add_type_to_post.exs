defmodule Akedia.Repo.Migrations.AddTypeToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :type, :string
    end
  end
end
