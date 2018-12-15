defmodule AkediaWeb.ImageView do
  use AkediaWeb, :view
  alias Akedia.Images.ImageUploader

  def image_url(image, version \\ :thumb) do
    Path.join(
      Routes.post_url(AkediaWeb.Endpoint, :index),
      ImageUploader.url({image.name, image}, version)
    )
  end
end
