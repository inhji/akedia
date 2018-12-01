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
end
