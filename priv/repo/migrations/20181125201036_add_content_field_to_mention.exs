defmodule Akedia.Repo.Migrations.AddContentFieldToMention do
  use Ecto.Migration

  def change do
    alter table(:mentions) do
      add :content, :text
      add :content_html, :text
    end
  end
end
