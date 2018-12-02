defmodule Akedia.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Posts.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(posts_query())
  end

  def list_posts_paginated(params) do
    Repo.paginate(posts_query(), params)
  end

  defp posts_query do
    from p in Post,
      order_by: [desc: :inserted_at],
      preload: [:mentions, :tags]
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    Post
    |> Repo.get!(id)
    |> Repo.preload([:mentions, :tags])
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    tags = prepare_tags(attrs)

    %Post{}
    |> Repo.preload([:tags])
    |> Post.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, Enum.map(tags, &Akedia.Tags.change_tag/1))
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    tags = prepare_tags(attrs)

    post
    |> Post.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:tags, Enum.map(tags, &Akedia.Tags.change_tag/1))
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  @doc """
  Returns a list of tags from a binary comma separated list
  """
  defp get_tags_list(attrs) do
    attrs["tags"]
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
  end

  @doc """
  Gets tags from the database
  """
  defp prepare_tags(attrs) do
    case tags = attrs["tags"] do
      nil ->
        []

      _ ->
        tags_list = get_tags_list(attrs)
        Repo.all(from t in Akedia.Tags.Tag, where: t.name in ^tags_list)
    end
  end
end
