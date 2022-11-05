defmodule ScrumPoker.AccountsTest do
  use ScrumPoker.DataCase, async: true

  alias ScrumPoker.Accounts

  describe "users" do
    alias ScrumPoker.Accounts.User

    import ScrumPoker.AccountsFixtures

    @invalid_attrs %{avatar_url: nil, deck_color: nil, deck_sequence: nil, display_name: nil, email: nil, github_token: nil, uuid: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{avatar_url: "some avatar_url", deck_color: "some deck_color", deck_sequence: :linear, display_name: "some display_name", email: "some email", github_token: "some github_token", uuid: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.avatar_url == "some avatar_url"
      assert user.deck_color == "some deck_color"
      assert user.deck_sequence == :linear
      assert user.display_name == "some display_name"
      assert user.email == "some email"
      assert user.github_token == "some github_token"
      assert user.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{avatar_url: "some updated avatar_url", deck_color: "some updated deck_color", deck_sequence: :tshirt, display_name: "some updated display_name", email: "some updated email", github_token: "some updated github_token", uuid: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.avatar_url == "some updated avatar_url"
      assert user.deck_color == "some updated deck_color"
      assert user.deck_sequence == :tshirt
      assert user.display_name == "some updated display_name"
      assert user.email == "some updated email"
      assert user.github_token == "some updated github_token"
      assert user.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
