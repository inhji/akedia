defmodule Akedia.Posts.Post do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :type, :string
    field :title, :string
    field :content, :string
    field :content_html, :string
    field :excerpt, :string
    field :image, Akedia.Posts.PostImage.Type

    field :in_reply_to, :string
    field :bookmark_of, :string
    field :like_of, :string
    field :repost_of, :string

    field :syndicate_to_github, :boolean

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
      :title,
      :content,
      :content_html,
      :in_reply_to,
      :bookmark_of,
      :like_of,
      :repost_of,
      :syndicate_to_github
    ])
    |> set_post_type
    |> validate_required(:type)
    |> validate_inclusion(:type, valid_post_types())
    |> maybe_create_excerpt
    |> maybe_render_markdown
  end

  def photo_changeset(post, attrs) do
    post
    |> cast_attachments(attrs, [:image])
  end

  defp valid_post_types, do: ["note", "like", "bookmark", "reply", "repost", "article"]

  @doc """
  Sets the post type according to certain properties

  article must be first, because a bookmark, repost, reply
  can also have a title. Putting article after that
  would set the type to article again. this means that
  the type may be set multiple times.
  """
  defp set_post_type(changeset) do
    changeset
    |> maybe_set_type_to("article", :title)
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

  defp render_markdown(markdown) do
    opts = %Earmark.Options{code_class_prefix: "language-"}
    Earmark.as_html!(markdown, opts)
  end

  defp maybe_render_markdown(changeset) do
    new_content = get_change(changeset, :content)
    is_empty? = is_nil(get_field(changeset, :content))

    cond do
      is_empty? ->
        put_change(changeset, :content_html, "")

      is_nil(new_content) ->
        changeset

      true ->
        put_change(changeset, :content_html, render_markdown(new_content))
    end
  end
end
