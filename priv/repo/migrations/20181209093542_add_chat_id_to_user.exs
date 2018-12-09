defmodule Akedia.Repo.Migrations.AddChatIdToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :chat_id, :integer
    end
  end
end
