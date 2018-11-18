defmodule Akedia.Mentions do
  @moduledoc """
  The Mentions context.
  """

  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Mentions.Mention

  @doc """
  Returns the list of mentions.

  ## Examples

      iex> list_mentions()
      [%Mention{}, ...]

  """
  def list_mentions do
    Repo.all(Mention)
  end

  @doc """
  Gets a single mention.

  Raises `Ecto.NoResultsError` if the Mention does not exist.

  ## Examples

      iex> get_mention!(123)
      %Mention{}

      iex> get_mention!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mention!(id), do: Repo.get!(Mention, id)

  def get_mention_by_source_and_target(source, target) do
    query =
      from m in Mention,
        where: m.source_url == ^source and m.target_url == ^target

    Repo.one!(query)
  end

  @doc """
  Creates a mention.

  ## Examples

      iex> create_mention(%{field: value})
      {:ok, %Mention{}}

      iex> create_mention(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mention(attrs \\ %{}) do
    %Mention{}
    |> Mention.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a mention.

  ## Examples

      iex> update_mention(mention, %{field: new_value})
      {:ok, %Mention{}}

      iex> update_mention(mention, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mention(%Mention{} = mention, attrs) do
    mention
    |> Mention.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Mention.

  ## Examples

      iex> delete_mention(mention)
      {:ok, %Mention{}}

      iex> delete_mention(mention)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mention(%Mention{} = mention) do
    Repo.delete(mention)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mention changes.

  ## Examples

      iex> change_mention(mention)
      %Ecto.Changeset{source: %Mention{}}

  """
  def change_mention(%Mention{} = mention) do
    Mention.changeset(mention, %{})
  end
end
