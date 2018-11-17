defmodule AkediaWeb.PostView do
  use AkediaWeb, :view
  alias Akedia.Posts.PostImage

  def image(post) do
    PostImage.url({post.image, post}, :thumb)
  end

  def has_image?(post) do
    !!post.image
  end
end
