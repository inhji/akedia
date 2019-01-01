defmodule Akedia.Repo.Migrations.AddMenuIdToLinks do
  use Ecto.Migration

  def change do
    alter table(:links) do
      add :menu_id, references(:menus, on_delete: :delete_all)
    end
  end
end
