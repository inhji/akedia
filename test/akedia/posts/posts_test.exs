defmodule Akedia.PostsTest do
  use Akedia.DataCase

  alias Akedia.Posts

  describe "posts" do
    alias Akedia.Posts.Post

    @valid_attrs %{content: "some content"}
    @update_attrs %{content: "some updated content"}
    @invalid_attrs %{content: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Posts.create_post(@valid_attrs)
      assert post.content == "some content"
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Posts.update_post(post, @update_attrs)
      assert post.content == "some updated content"
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end

    test "parse_tags/1 splits a string and returns a list" do
      assert Posts.parse_tags("foo,bar") == ["foo", "bar"]
      assert Posts.parse_tags("foo    ,bar    ") == ["foo", "bar"]
      assert Posts.parse_tags("   foo    ,   bar    ") == ["foo", "bar"]
    end

    test "parse_tags/1 returns a list of strings unchanged" do
      assert Posts.parse_tags(["foo", "bar"]) == ["foo", "bar"]
      assert Posts.parse_tags(["foo ", "bar"]) == ["foo", "bar"]
    end

    test "parse_tags/1 returns an empty list for invalid arguments" do
      assert Posts.parse_tags(1) == []
      assert Posts.parse_tags(nil) == []
      assert Posts.parse_tags(%{"tag1" => "foo"}) == []
      assert Posts.parse_tags(%{:tag1 => "foo"}) == []
    end
  end
end
