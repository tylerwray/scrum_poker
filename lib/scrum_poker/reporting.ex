defmodule ScrumPoker.Reporting do
  @moduledoc """
  Reporting functions for Scrum Poker.
  """

  alias ScrumPoker.Poker.Game

  @shirt_size_values %{
    "XS" => 1,
    "SM" => 2,
    "MD" => 3,
    "LG" => 4,
    "XL" => 5
  }

  @doc """
  Calculate the average of the given cards for a deck sequence.

  ## Examples

    iex> Reporting.average(:tshirt, ["XS", "LG", "XL", "LG"])
    "LG"

    iex> Reporting.average(:linear, ["2", "2", "3", "4", "1", "1"])
    2

    iex> Reporting.average(:fibonacci, ["2", "2", "3", "5", "1", "1"])
    2
  """
  def average(:tshirt, cards) do
    parsed_cards = cards |> Enum.map(&Map.get(@shirt_size_values, &1)) |> Enum.reject(&is_nil/1)

    if Enum.empty?(parsed_cards) do
      nil
    else
      average = Enum.sum(parsed_cards) / Enum.count(parsed_cards)

      # Reverse the values map to find the shirt size.
      @shirt_size_values
      |> Map.new(fn {k, v} -> {v, k} end)
      |> Map.get(round(average))
    end
  end

  def average(:fibonacci, cards) do
    parsed_cards = cards |> Enum.map(&safely_to_integer/1) |> Enum.reject(&is_nil/1)

    if Enum.empty?(parsed_cards) do
      nil
    else
      average = Enum.sum(parsed_cards) / Enum.count(parsed_cards)

      # Get the lowest fibonacci number to the average.
      Game.fibonacci_choices()
      |> Enum.map(&String.to_integer/1)
      |> Enum.min_by(&abs(&1 - average))
    end
  end

  def average(:linear, cards) do
    parsed_cards = cards |> Enum.map(&safely_to_integer/1) |> Enum.reject(&is_nil/1)

    if Enum.empty?(parsed_cards) do
      nil
    else
      round(Enum.sum(parsed_cards) / Enum.count(parsed_cards))
    end
  end

  @doc """
  Calculate the minimum of the given cards for a deck sequence.

  ## Examples

    iex> Reporting.minimum(:tshirt, ["XS", "LG", "XL", "LG"])
    "XS"

    iex> Reporting.minimum(:linear, ["2", "2", "3", "4", "1", "1"])
    1

  """
  def minimum(:tshirt, cards) do
    parsed_cards =
      cards
      |> Enum.map(&Map.get(@shirt_size_values, &1))
      |> Enum.reject(&is_nil/1)

    if Enum.empty?(parsed_cards) do
      nil
    else
      @shirt_size_values
      |> Map.new(fn {k, v} -> {v, k} end)
      |> Map.get(Enum.min(parsed_cards))
    end
  end

  def minimum(_sequence, cards) do
    parsed_cards =
      cards
      |> Enum.map(&safely_to_integer/1)
      |> Enum.reject(&is_nil/1)

    if Enum.empty?(parsed_cards) do
      nil
    else
      Enum.min(parsed_cards)
    end
  end

  @doc """
  Calculate the maximum of the given cards for a deck sequence.

  ## Examples

    iex> Reporting.minimum(:tshirt, ["XS", "LG", "XL", "LG"])
    "XS"

    iex> Reporting.minimum(:linear, ["2", "2", "3", "4", "1", "1"])
    1

  """
  def maximum(:tshirt, cards) do
    parsed_cards =
      cards
      |> Enum.map(&Map.get(@shirt_size_values, &1))
      |> Enum.reject(&is_nil/1)

    if Enum.empty?(parsed_cards) do
      nil
    else
      @shirt_size_values
      |> Map.new(fn {k, v} -> {v, k} end)
      |> Map.get(Enum.max(parsed_cards))
    end
  end

  def maximum(_sequence, cards) do
    parsed_cards =
      cards
      |> Enum.map(&safely_to_integer/1)
      |> Enum.reject(&is_nil/1)

    if Enum.empty?(parsed_cards) do
      nil
    else
      Enum.max(parsed_cards)
    end
  end

  defp safely_to_integer(str) do
    case Integer.parse(str) do
      {int, _remainder} -> int
      # Remove emoji or other non-integer values
      _ -> nil
    end
  end
end
