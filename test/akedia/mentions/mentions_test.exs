defmodule Akedia.MentionsTest do
  use Akedia.DataCase

  alias Akedia.Mentions

  describe "mentions" do
    alias Akedia.Mentions.Mention

    @valid_attrs %{author: "some author", author_avatar: "some author_avatar", author_url: "some author_url", excerpt: "some excerpt", mention_type: "some mention_type", source_url: "some source_url", target_url: "some target_url", title: "some title"}
    @update_attrs %{author: "some updated author", author_avatar: "some updated author_avatar", author_url: "some updated author_url", excerpt: "some updated excerpt", mention_type: "some updated mention_type", source_url: "some updated source_url", target_url: "some updated target_url", title: "some updated title"}
    @invalid_attrs %{author: nil, author_avatar: nil, author_url: nil, excerpt: nil, mention_type: nil, source_url: nil, target_url: nil, title: nil}

    def mention_fixture(attrs \\ %{}) do
      {:ok, mention} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Mentions.create_mention()

      mention
    end

    test "list_mentions/0 returns all mentions" do
      mention = mention_fixture()
      assert Mentions.list_mentions() == [mention]
    end

    test "get_mention!/1 returns the mention with given id" do
      mention = mention_fixture()
      assert Mentions.get_mention!(mention.id) == mention
    end

    test "create_mention/1 with valid data creates a mention" do
      assert {:ok, %Mention{} = mention} = Mentions.create_mention(@valid_attrs)
      assert mention.author == "some author"
      assert mention.author_avatar == "some author_avatar"
      assert mention.author_url == "some author_url"
      assert mention.excerpt == "some excerpt"
      assert mention.mention_type == "some mention_type"
      assert mention.source_url == "some source_url"
      assert mention.target_url == "some target_url"
      assert mention.title == "some title"
    end

    test "create_mention/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mentions.create_mention(@invalid_attrs)
    end

    test "update_mention/2 with valid data updates the mention" do
      mention = mention_fixture()
      assert {:ok, %Mention{} = mention} = Mentions.update_mention(mention, @update_attrs)
      assert mention.author == "some updated author"
      assert mention.author_avatar == "some updated author_avatar"
      assert mention.author_url == "some updated author_url"
      assert mention.excerpt == "some updated excerpt"
      assert mention.mention_type == "some updated mention_type"
      assert mention.source_url == "some updated source_url"
      assert mention.target_url == "some updated target_url"
      assert mention.title == "some updated title"
    end

    test "update_mention/2 with invalid data returns error changeset" do
      mention = mention_fixture()
      assert {:error, %Ecto.Changeset{}} = Mentions.update_mention(mention, @invalid_attrs)
      assert mention == Mentions.get_mention!(mention.id)
    end

    test "delete_mention/1 deletes the mention" do
      mention = mention_fixture()
      assert {:ok, %Mention{}} = Mentions.delete_mention(mention)
      assert_raise Ecto.NoResultsError, fn -> Mentions.get_mention!(mention.id) end
    end

    test "change_mention/1 returns a mention changeset" do
      mention = mention_fixture()
      assert %Ecto.Changeset{} = Mentions.change_mention(mention)
    end
  end
end
