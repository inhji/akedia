defmodule AkediaWeb.LayoutView do
  use AkediaWeb, :view

  def render_layout(layout, assigns, do: content) do
    render(layout, Map.put(assigns, :inner_layout, content))
  end

  def get_indie_config_value(key) when is_atom(key) do
    Application.get_env(:akedia, :indie)[key]
  end
end
