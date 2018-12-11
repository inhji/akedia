defmodule Akedia.Micropub.PropertiesTest do
  use Akedia.DataCase

  describe "micropub_handler" do
    alias Akedia.Micropub.Properties

    @create_attrs %{
      "name" => ["grandiose title"],
      "content" => ["foo"],
      "like-of" => ["https://google.de"],
      "bookmark-of" => ["https://google.de"],
      "in-reply-to" => ["https://google.de"],
      "category" => ["foo", "bar"]
    }

    @create_result %{
      title: "grandiose title",
      content: "foo",
      like_of: "https://google.de",
      bookmark_of: "https://google.de",
      in_reply_to: "https://google.de",
      tags: ["foo", "bar"]
    }

    @add_attrs %{
      "category" => ["foo", "bar"]
    }

    @replace_attrs %{
      "name" => ["even more grandiose title"]
    }

    @delete_attrs %{
      "content" => ["foo"]
    }

    @update_result %{
      title: "even more grandiose title",
      tags: ["foo", "bar"],
      content: nil
    }

    test "parse_properties/1 parses properties correctly" do
      assert Properties.parse(@create_attrs) == @create_result
    end

    test "parse_properties/3 parses properties correctly" do
      props = Properties.parse(@replace_attrs, @add_attrs, @delete_attrs)
      assert props == @update_result
    end
  end
end
