defmodule Akedia.Repo.Migrations.AddContentHtmlToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :content_html, :text
    end
  end
end
