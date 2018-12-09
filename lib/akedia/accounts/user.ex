defmodule Akedia.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field :encrypted_password, :string
    field :username, :string
    field :email, :string
    field :chat_id, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :encrypted_password, :email, :chat_id])
    |> validate_required([:username, :encrypted_password])
    |> unique_constraint(:username)
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
  end
end
