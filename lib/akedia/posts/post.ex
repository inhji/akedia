defmodule Akedia.Posts.Post do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :content_html, :string
    field :excerpt, :string
    field :image, Akedia.Posts.PostImage.Type

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content, :content_html])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:content])
    |> maybe_create_excerpt
    |> maybe_render_markdown
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
