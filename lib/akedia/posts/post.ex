defmodule Akedia.Posts.Post do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :type, :string
    field :content, :string
    field :content_html, :string
    field :excerpt, :string
    field :image, Akedia.Posts.PostImage.Type

    field :in_reply_to, :string
    field :bookmark_of, :string
    field :like_of, :string
    field :repost_of, :string

    has_many :mentions, Akedia.Mentions.Mention

    many_to_many :tags,
                 Akedia.Tags.Tag,
                 join_through: "posts_tags",
                 on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [
      :type,
      :content,
      :content_html,
      :in_reply_to,
      :bookmark_of,
      :like_of,
      :repost_of
    ])
    |> set_post_type
    |> validate_required(:type)
    |> validate_inclusion(:type, valid_post_types())
    |> cast_attachments(attrs, [:image])
    |> maybe_create_excerpt
    |> maybe_render_markdown
  end

  defp valid_post_types, do: ["note", "like", "bookmark", "reply", "repost"]

  defp set_post_type(changeset) do
    changeset
    |> maybe_set_type_to("like", :like_of)
    |> maybe_set_type_to("bookmark", :bookmark_of)
    |> maybe_set_type_to("repost", :repost_of)
    |> maybe_set_type_to("reply", :in_reply_to)
    |> maybe_set_default_type("note")
  end

  defp maybe_set_type_to(changeset, type, condition_field) do
    case get_field(changeset, condition_field) do
      nil -> changeset
      _ -> put_change(changeset, :type, type)
    end
  end

  defp maybe_set_default_type(changeset, default) do
    case get_field(changeset, :type) do
      nil -> put_change(changeset, :type, default)
      _ -> changeset
    end
  end

  defp maybe_create_excerpt(changeset) do
    if new_content = get_change(changeset, :content) do
      excerpt = String.slice(new_content, 0, 30)
      put_change(changeset, :excerpt, excerpt)
    else
      changeset
    end
  end

  defp maybe_render_markdown(changeset) do
    if new_content = get_change(changeset, :content) do
      markdown = Earmark.as_html!(new_content)
      put_change(changeset, :content_html, markdown)
    else
      changeset
    end
  end
end
