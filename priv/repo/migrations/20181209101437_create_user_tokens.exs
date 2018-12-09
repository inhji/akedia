defmodule Akedia.Repo.Migrations.CreateLoginTokens do
  use Ecto.Migration

  def change do
    create table(:user_tokens) do
      add :token, :string
      add :user_id, :integer

      timestamps()
    end
  end
end
