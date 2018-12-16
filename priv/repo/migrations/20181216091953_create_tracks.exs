defmodule Akedia.Repo.Migrations.CreateTracks do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :name, :string
      add :artist, :string
      add :album, :string
      add :timestamp, :integer
      add :listened_at, :naive_datetime

      timestamps()
    end

    create unique_index(:tracks, [:listened_at])
  end
end
