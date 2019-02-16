defmodule AkediaWeb.LayoutView do
  use AkediaWeb, :view
  alias AkediaWeb.PageController
  alias AkediaWeb.PostController
  alias AkediaWeb.ImageController

  def page_title(conn) do
    %{
      :phoenix_action => action,
      :phoenix_controller => controller
    } = conn.private

    title =
      case controller do
        PageController ->
          case action do
            :index -> "Home"
            :now -> "Now"
            _ -> nil
          end

        PostController ->
          case action do
            :index ->
              "Posts"

            :by_type ->
              post_type = conn.params["type"]
              String.capitalize(post_type) <> "s"

            :show ->
              post_id = conn.params["id"]
              "Post #{post_id}"

            _ ->
              nil
          end

        ImageController ->
          case action do
            :index ->
              "Photos"

            :show ->
              image_id = conn.params["id"]
              "Photo #{image_id}"

            _ ->
              nil
          end

        _ ->
          nil
      end

    if is_nil(title) do
      "Technos & Psyche"
    else
      "#{title} - Technos & Psyche"
    end
  end

  def page_subtitle do
    subtitles = [
      "I'm ready to lose my mind but instead I use my mind.",
      "If you are not tuned into happiness, change the station.",
      "This is not the right way. But it's my way.",
      "We don’t make mistakes, we just have happy little accidents.",
      "Live slow, die old."
    ]

    Enum.random(subtitles)
  end

  def js_view_path(conn, view_template) do
    IO.inspect(view_name(conn))
    IO.inspect(template_name(view_template))

    [view_name(conn), template_name(view_template)]
    |> Enum.join("/")
  end

  defp view_name(conn) do
    conn
    |> view_module
    |> Phoenix.Naming.resource_name
    |> String.replace("_view", "")
  end

  defp template_name(template) do
    template
    |> String.split(".")
    |> Enum.at(0)
  end

  def libravatar(email) do
    id =
      :crypto.hash(:md5, email)
      |> Base.encode16()
      |> String.downcase()

    "https://seccdn.libravatar.org/avatar/#{id}?s=96"
  end

  def get_indie_config_value(key) when is_atom(key) do
    Application.get_env(:akedia, :indie)[key]
  end
end
