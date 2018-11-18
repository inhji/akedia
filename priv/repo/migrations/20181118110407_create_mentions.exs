defmodule Akedia.Repo.Migrations.CreateMentions do
  use Ecto.Migration

  def change do
    create table(:mentions) do
      add :source_url, :string, null: false
      add :target_url, :string, null: false
      add :title, :string
      add :excerpt, :string
      add :author, :string, null: false
      add :author_url, :string
      add :author_avatar, :string
      add :mention_type, :string, null: false
      add :post_id, references(:posts)

      timestamps()
    end

  end
end
