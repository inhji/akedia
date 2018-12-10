defmodule AkediaWeb.LayoutView do
  use AkediaWeb, :view

  def render_layout(layout, assigns, do: content) do
    render(layout, Map.put(assigns, :inner_layout, content))
  end

  def page_subtitle do
    subtitles = [
      "I'm ready to lose my mind but instead I use my mind.",
      "If you are not tuned into happiness, change the station.",
      "This is not the right way. But it's my way."
    ]

    Enum.random(subtitles)
  end

  def libravatar(email) do
    id =
      :crypto.hash(:md5, email)
      |> Base.encode16()
      |> String.downcase()

    "https://seccdn.libravatar.org/avatar/#{id}"
  end

  def get_indie_config_value(key) when is_atom(key) do
    Application.get_env(:akedia, :indie)[key]
  end
end
