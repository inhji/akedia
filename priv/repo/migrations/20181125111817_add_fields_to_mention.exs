defmodule Akedia.Repo.Migrations.AddFieldsToMention do
  use Ecto.Migration

  def change do
    alter table(:mentions) do
      add :mention_value, :string
    end
  end
end
