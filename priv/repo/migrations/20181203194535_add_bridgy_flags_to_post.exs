defmodule Akedia.Repo.Migrations.AddBridgyFlagsToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :syndicate_to_github, :boolean
    end
  end
end
