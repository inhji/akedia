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

  def ribbon(post) do
    {class, icon} =
      cond do
        post.in_reply_to -> {"is-success", "fas fa-comment"}
        post.like_of -> {"is-danger", "fas fa-heart"}
        post.bookmark_of -> {"is-primary", "fas fa-bookmark"}
        post.repost_of -> {"is-warning", "fas fa-recycle"}
        true -> {nil, nil}
      end

    cond do
      is_nil(class) -> ""
      true -> raw("<div class='ribbon is-small #{class}'><i class='#{icon}'></i></div>")
    end
  end
end
