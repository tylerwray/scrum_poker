defmodule ScrumPoker.Poker.Game do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__

  @deck_sequences [
    :fibonacci,
    :linear,
    :tshirt
  ]

  @deck_cards %{
    fibonacci: ["1", "2", "3", "5", "8", "13", "21", "34", "55", "89", "144"],
    linear: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
    tshirt: ["XS", "SM", "MD", "LG", "XL"]
  }

  schema "games" do
    field :created_by, Ecto.UUID
    field :deck_sequence, Ecto.Enum, values: @deck_sequences, default: List.first(@deck_sequences)
    field :description, :string
    field :join_code, :string
    field :deck, {:array, :string}, virtual: true

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:created_by, :deck_sequence, :description, :join_code])
    |> validate_length(:join_code, is: 4)
    |> validate_format(:join_code, join_code_regex())
    |> validate_required([:created_by, :deck_sequence, :join_code])
  end

  def join_code_regex, do: ~r/^[a-zA-Z0-9]+$/

  def add_deck(%Game{} = game) do
    %{game | deck: @deck_cards[game.deck_sequence] ++ ["🤷‍♀️", "☕️"]}
  end

  def add_deck(value) do
    value
  end

  def fibonacci_choices, do: @deck_cards[:fibonacci]
end
