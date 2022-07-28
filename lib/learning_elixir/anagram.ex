defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    base = map_frequencies(base)
    candidates
    |> Stream.map(&map_frequencies(&1))
    |> Stream.filter(&anagram?(base, &1))
    |> Enum.map(&key(&1))
  end

  defp map_frequencies(string) do
    string
    |> String.downcase()
    |> String.to_charlist()
    |> Enum.reduce(%{}, &increment_frequency(&1, &2))
    |> (&(%{string => &1})).()
  end

  defp increment_frequency(c, acc), do: Map.get_and_update(acc, c, &{&1, (&1 || 0) + 1}) |> elem(1)

  defp anagram?(base, target) do
    frequencies_equal? = Map.equal?(value(base), value(target))
    different_from_base? = String.downcase(key(base)) != String.downcase(key(target))

    frequencies_equal? and different_from_base?
  end

  defp value(map), do: map |> Map.values() |> List.first()
  defp key(map), do: map |> Map.keys() |> List.first()
end
