defmodule ScrumPoker.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias ScrumPoker.Repo

  alias ScrumPoker.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      nil

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Gets a single user by a specific attribute.

  ## Examples

      iex> get_user_by(uuid: "cdcc2fd3-09e5-4631-949e-4014a2e4e7b9")
      %User{}

      iex> get_user(email: "test@example.com")
      nil

  """
  def get_user_by(opts), do: Repo.get_by(User, opts)

  def register_github_user(attrs) do
    if user = get_user_by(email: attrs.email) do
      update_user(user, %{github_token: attrs.github_token})
    else
      create_user(%{
        avatar_url: attrs.avatar_url,
        display_name: attrs.display_name,
        email: attrs.email,
        github_token: attrs.github_token
      })
    end
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{uuid: Ecto.UUID.generate()}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def create_anonymous_user do
    %{uuid: Ecto.UUID.generate(), display_name: "Anonymous #{random_animal()}", deck_color: Enum.random(User.preset_deck_colors())}
  end

  defp random_animal do
    Enum.random([
      "Rabbit",
      "Aardvark",
      "Giraffe",
      "Kitten",
      "Dog",
      "Wolf",
      "Hen",
      "Chicken",
      "Donkey"
    ])
  end
end
