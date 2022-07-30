defmodule Scrabble do
  @multiple_letters_to_values %{
    ~w(A E I O U L N R S T) => 1,
    ~w(D G) => 2,
    ~w(B C M P) => 3,
    ~w(F H V W Y) => 4,
    ~w(K) => 5,
    ~w(J X) => 8,
    ~w(Q Z) => 10
  }

  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t()) :: non_neg_integer
  def score(word) do
    letter_values = map_letter_to_value(@multiple_letters_to_values)
    score(word, letter_values)
  end

  defp score(word, letter_values) do
    word
    |> String.upcase()
    |> String.graphemes()
    |> Stream.map(&(Map.get(letter_values, &1) || 0))
    |> Enum.sum()
  end

  defp map_letter_to_value(letters_to_values) do
    letters_to_values
    |> Enum.reduce(%{}, &expand_letter_map/2)
  end

  defp expand_letter_map({letters, points}, map) do
    Map.merge(map, Map.new(letters, &{&1, points}))
  end

end
