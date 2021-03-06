defmodule Akedia.Mentions.Mention do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mentions" do
    belongs_to :post, Akedia.Posts.Post

    field :source_url, :string, null: false
    field :target_url, :string, null: false
    field :author, :string, null: false
    field :author_avatar, :string
    field :author_url, :string
    field :title, :string
    field :excerpt, :string
    field :mention_type, :string, null: false
    field :mention_value, :string
    field :content, :string
    field :content_html, :string

    timestamps()
  end

  @doc false
  def changeset(mention, attrs) do
    mention
    |> cast(attrs, [
      :source_url,
      :target_url,
      :title,
      :excerpt,
      :author,
      :author_url,
      :author_avatar,
      :mention_type,
      :mention_value,
      :post_id
    ])
    |> validate_required([
      :source_url,
      :target_url,
      :author,
      :mention_type
    ])
  end
end
