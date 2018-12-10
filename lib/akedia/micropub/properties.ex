defmodule Akedia.Micropub.Properties do
  @array_attributes ["category"]

  @allowed_properties %{
    "category" => :tags,
    "like-of" => :like_of,
    "bookmark-of" => :bookmark_of,
    "in-reply-to" => :in_reply_to,
    "content" => :content,
    "title" => :title
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

  def add_replace_properties({k, [first | last]}, props) do
    case key = @allowed_properties[k] do
      nil ->
        props

      _ ->
        if Enum.member?(@array_attributes, k) do
          Map.put(props, key, [first | last])
        else
          Map.put(props, key, first)
        end
    end
  end

  def remove_properties({k, _v}, props) do
    case key = @allowed_properties[k] do
      nil -> props
      _ -> Map.put(props, key, "nil")
    end
  end
end
