defmodule ScrumPoker.Poker do
  @moduledoc """
  The Poker context.
  """

  import Ecto.Query, warn: false
  alias ScrumPoker.Repo

  alias ScrumPoker.Poker.Game

  @doc """
  Check if a game code is valid using the format required for the DB.
  """
  def join_code_valid?(join_code) do
    String.match?(join_code, Game.join_code_regex())
  end

  @doc """
  Check if a game code exists.
  """
  def join_code_exists?(join_code) do
    Repo.exists?(from g in Game, where: g.join_code == ^join_code)
  end

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Delete all prior games created by the user given.
  """
  def delete_existing_user_games(user_uuid) do
    Repo.delete_all(from g in Game, where: g.created_by == ^user_uuid)
  end

  @code_characters ~w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9)

  @doc """
  Generate a game join code.
  """
  def generate_join_code do
    @code_characters
    |> Enum.shuffle()
    |> Enum.take(4)
    |> Enum.join()
  end

  @doc """
  Gets a single game by any column.

  ## Examples

      iex> get_game_by(join_code: "1234")
      %Game{}

      iex> get_game_by(created_by: "92f90291-8246-4d76-82b6-aa18074dbcea")
      nil

  """
  def get_game_by(opts) do
    Game
    |> Repo.get_by(opts)
    |> Game.add_deck()
  end
end
