defmodule AkediaWeb.Helpers.Input do
  use Phoenix.HTML

  def tag_input(form, field, placeholder \\ "") do
    values = Phoenix.HTML.Form.input_value(form, field) || [""]
    name = Phoenix.HTML.Form.input_name(form, field)

    tag(:input,
      name: name,
      type: "text",
      class: "input",
      placeholder: placeholder,
      value:
        values
        |> Enum.map(fn tag -> tag.name end)
        |> Enum.join(",")
    )
  end
end
