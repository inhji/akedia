defmodule Akedia.Repo.Migrations.AddIndieFieldsToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :in_reply_to, :string
      add :like_of, :string
      add :repost_of, :string
      add :bookmark_of, :string
    end
  end
end
