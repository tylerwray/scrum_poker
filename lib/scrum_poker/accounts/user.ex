defmodule ScrumPoker.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @preset_deck_colors ~w(
    pink_purple_gradient
    orange_blue_gradient
    orange_purple_gradient
    yellow_red_gradient
    teal_yellow_gradient
    red_green_gradient
  )

  schema "users" do
    field :avatar_url, :string
    field :color_scheme, Ecto.Enum, values: [:light, :dark, :system], default: :dark
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
      :avatar_url,
      :color_scheme,
      :deck_color,
      :display_name,
      :email,
      :github_token,
      :uuid
    ])
    |> validate_required([
      :avatar_url,
      :color_scheme,
      :deck_color,
      :github_token,
      :uuid
    ])
    |> validate_required(:display_name, message: "Must include display name.")
    |> validate_required(:email, message: "Must include email.")
    |> unique_constraint(:uuid)
  end

  def preset_deck_colors, do: @preset_deck_colors
end
