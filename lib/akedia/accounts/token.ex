defmodule Akedia.Accounts.Token do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_tokens" do
    field :token, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :user_id])
    |> validate_required([:token, :user_id])
  end
end
