defmodule ETL do
  @doc """
  Transforms an old Scrabble score system to a new one.

  ## Examples

    iex> ETL.transform(%{1 => ["A", "E"], 2 => ["D", "G"]})
    %{"a" => 1, "d" => 2, "e" => 1, "g" => 2}
  """
  @spec transform(map) :: map
  def transform(input) do
    input
    |> Enum.reduce(%{}, fn {points, letters}, acc -> gen_letter_keys(points, letters, acc) end)
  end

  defp gen_letter_keys(points, letters, acc) do
    letters
    |> Enum.reduce(acc, fn letter, map -> Map.put(map, String.downcase(letter), points) end)
  end
end
