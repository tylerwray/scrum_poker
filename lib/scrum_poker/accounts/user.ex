defmodule ScrumPoker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @preset_deck_colors ~w(pink_purple_fade)

  schema "users" do
    field :avatar_url, :string
    field :deck_color, :string, default: List.first(@preset_deck_colors)
    field :display_name, :string
    field :email, :string
    field :github_token, :string
    field :uuid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :uuid,
      :email,
      :display_name,
      :avatar_url,
      :github_token,
      :deck_color
    ])
    |> validate_required([
      :uuid,
      :email,
      :display_name,
      :avatar_url,
      :github_token,
      :deck_color
    ])
    |> unique_constraint(:uuid)
  end
end
