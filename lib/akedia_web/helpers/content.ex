defmodule AkediaWeb.Helpers.Content do
  alias Akedia.Images.ImageUploader
  alias AkediaWeb.Router.Helpers, as: Routes

  def image_url(image, version \\ :thumb) do
    Path.join(
      Routes.page_url(AkediaWeb.Endpoint, :index),
      ImageUploader.url({image.name, image}, version)
    )
  end
end
