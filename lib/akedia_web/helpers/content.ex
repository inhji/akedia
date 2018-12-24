defmodule AkediaWeb.Helpers.Content do
  import Phoenix.HTML.Link
  alias Akedia.Images.ImageUploader
  alias AkediaWeb.Router.Helpers, as: Routes

  def image_url(image, version \\ :thumb) do
    Path.join(
      Routes.page_url(AkediaWeb.Endpoint, :index),
      ImageUploader.url({image.name, image}, version)
    )
  end

  def tags_as_string(tags) do
    tags
    |> Enum.map(fn t -> t.name end)
    |> Enum.join(", ")
  end

  def from_now_link(post) do
    link(from_now(post.inserted_at),
      to: Routes.post_url(AkediaWeb.Endpoint, :show, post.id),
      class: "u-url has-text-grey",
      title: iso_date(post.inserted_at)
    )
  end

  def from_now(date) do
    Timex.from_now(date, "en")
  end

  def iso_date(date) do
    Timex.format!(date, "{ISO:Extended:Z}")
  end
end
