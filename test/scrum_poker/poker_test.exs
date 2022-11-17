defmodule ScrumPoker.PokerTest do
  use ScrumPoker.DataCase

  alias ScrumPoker.Poker
  alias ScrumPoker.AccountsFixtures

  describe "games" do
    alias ScrumPoker.Poker.Game

    @invalid_attrs %{created_by: nil, join_code: nil}

    test "create_game/1 with valid data creates a game" do
      user = AccountsFixtures.user_fixture()
      valid_attrs = %{created_by: user.uuid, join_code: "AB4D"}

      assert {:ok, %Game{} = game} = Poker.create_game(valid_attrs)
      assert game.created_by == user.uuid
      assert game.join_code == "AB4D"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Poker.create_game(@invalid_attrs)
    end
  end
end
