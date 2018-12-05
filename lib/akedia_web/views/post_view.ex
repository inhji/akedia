defmodule AkediaWeb.PostView do
  use AkediaWeb, :view
  alias Akedia.Posts.PostImage
  import Scrivener.HTML

  def image(post, version \\ :thumb) do
    PostImage.url({post.image, post}, version)
  end

  def has_image?(post) do
    !!post.image
  end

  def has_title?(post) do
    !!post.title
  end

  def content_class(post) do
    if has_title?(post), do: "", else: "p-name"
  end

  def ribbon(post) do
    {class, icon} =
      case post.type do
        "reply" -> {"is-success", "fas fa-comment"}
        "like" -> {"is-danger", "fas fa-heart"}
        "bookmark" -> {"is-primary", "fas fa-bookmark"}
        "repost" -> {"is-warning", "fas fa-recycle"}
        "article" -> {"is-link", "fas fa-pen-nib"}
        _ -> {nil, nil}
      end

    cond do
      is_nil(class) -> ""
      true -> raw("<div class='ribbon is-small #{class}'><i class='#{icon}'></i></div>")
    end
  end
end
