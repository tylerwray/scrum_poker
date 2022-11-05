defmodule ScrumPoker.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ScrumPoker.Accounts` context.
  """

  @doc """
  Generate a unique user uuid.
  """
  def unique_user_uuid do
    Ecto.UUID.generate()
  end

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        avatar_url: "some avatar_url",
        deck_color: "some deck_color",
        deck_sequence: :linear,
        display_name: "some display_name",
        email: "some email",
        github_token: "some github_token",
        uuid: unique_user_uuid()
      })
      |> ScrumPoker.Accounts.create_user()

    user
  end
end
