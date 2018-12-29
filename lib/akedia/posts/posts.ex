defmodule Akedia.Posts do
  @moduledoc """
  The Posts context.
  """

  require Logger

  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Posts.Post
  alias Akedia.Tags

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(posts_query())
  end

  def list_posts(types) do
    Repo.all(posts_query(types))
  end

  def list_posts_paginated(params) do
    Repo.paginate(posts_query(), params)
  end

  def list_posts_paginated(params, types) do
    Repo.paginate(posts_query(types), params)
  end

  def last_posts(type, limit \\ 1) do
    Repo.all(
      from p in posts_query([type]),
        limit: ^limit
    )
  end

  defp posts_query() do
    from p in Post,
      where: is_nil(p.is_page) or p.is_page == false,
      order_by: [desc: :inserted_at],
      preload: [:mentions, :tags]
  end

  defp posts_query(types) when is_list(types) do
    from p in posts_query(),
      where: p.type in ^types
  end

  def count_posts do
    Post
    |> Repo.aggregate(:count, :id)
  end

  def count_posts(type) do
    Post
    |> where(type: ^type)
    |> Repo.aggregate(:count, :id)
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
    tags = Tags.prepare_tags(attrs)

    %Post{}
    |> Repo.preload([:tags, :mentions])
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
    tags = Tags.prepare_tags(attrs)

    post
    |> Repo.preload(:tags)
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

  def soft_delete_post(%Post{} = post) do
    update_post(post, %{is_deleted: true})
  end

  def undelete_post(%Post{} = post) do
    update_post(post, %{is_deleted: false})
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
end
