defmodule Akedia.TagsTest do
  use Akedia.DataCase

  alias Akedia.Tags

  describe "tags" do
    alias Akedia.Tags.Tag

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def tag_fixture(attrs \\ %{}) do
      {:ok, tag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Tags.create_tag()

      tag
    end

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Tags.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Tags.get_tag!(tag.name) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      assert {:ok, %Tag{} = tag} = Tags.create_tag(@valid_attrs)
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tags.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{} = tag} = Tags.update_tag(tag, @update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Tags.update_tag(tag, @invalid_attrs)
      assert tag == Tags.get_tag!(tag.name)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Tags.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Tags.get_tag!(tag.name) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Tags.change_tag(tag)
    end

    test "parse_tags/1 splits a string and returns a list" do
      assert Tags.parse_tags("foo,bar") == ["foo", "bar"]
      assert Tags.parse_tags("foo    ,bar    ") == ["foo", "bar"]
      assert Tags.parse_tags("   foo    ,   bar    ") == ["foo", "bar"]
    end

    test "parse_tags/1 returns a list of strings unchanged" do
      assert Tags.parse_tags(["foo", "bar"]) == ["foo", "bar"]
      assert Tags.parse_tags(["foo ", "bar"]) == ["foo", "bar"]
    end

    test "parse_tags/1 returns an empty list for invalid arguments" do
      assert Tags.parse_tags(1) == []
      assert Tags.parse_tags(nil) == []
      assert Tags.parse_tags(%{"tag1" => "foo"}) == []
      assert Tags.parse_tags(%{:tag1 => "foo"}) == []
    end

    test "prepare_tags/1 fetches the tag models from a list of tags" do
      tag = tag_fixture()
      tags = Tags.prepare_tags(%{:tags => [tag.name]})

      assert tags == [tag]
    end

    test "prepare_tags/1 inserts unknown tags" do
      tag = tag_fixture()
      tags = Tags.prepare_tags(%{:tags => [tag.name, "foo"]})

      assert Enum.count(tags) == 2
      assert [tag, new_tag] = tags
      assert new_tag.name == "foo"
    end
  end
end
