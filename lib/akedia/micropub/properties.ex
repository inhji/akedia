defmodule Akedia.Micropub.Properties do
  @array_attributes ["category"]
  @html_attributes ["content"]

  @allowed_properties %{
    "category" => :tags,
    "like-of" => :like_of,
    "bookmark-of" => :bookmark_of,
    "in-reply-to" => :in_reply_to,
    "content" => :content,
    "name" => :title
  }

  def parse(properties) do
    properties
    |> Enum.reduce(%{}, &add_replace_properties/2)
  end

  def parse(replace, add, delete) do
    add_replace =
      replace
      |> Map.merge(add)
      |> Enum.reduce(%{}, &add_replace_properties/2)

    delete
    |> Enum.reduce(add_replace, &remove_properties/2)
  end

  def add_replace_properties({k, [head | tail]}, props) do
    case key = @allowed_properties[k] do
      nil ->
        props

      _ ->
        cond do
          Enum.member?(@array_attributes, k) ->
            Map.put(props, key, [head | tail])

          Enum.member?(@html_attributes, k) and is_map(head) ->
            value =
              cond do
                Map.has_key?(head, "html") -> head["html"]
                Map.has_key?(head, "value") -> head["value"]
                true -> ""
              end

            Map.put(props, key, value)

          true ->
            Map.put(props, key, head)
        end
    end
  end

  def remove_properties({k, _v}, props) do
    case key = @allowed_properties[k] do
      nil -> props
      _ -> Map.put(props, key, nil)
    end
  end
end
