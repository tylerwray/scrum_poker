defmodule ScrumPoker.PokerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ScrumPoker.Poker` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        created_by: "7488a646-e31f-11e4-aace-600308960662",
        join_code: "some join_code"
      })
      |> ScrumPoker.Poker.create_game()

    game
  end
end
