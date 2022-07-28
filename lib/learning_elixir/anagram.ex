defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates), do: for c <- candidates, anagram?(String.downcase(base), String.downcase(c)),
                                   do: c, into: []
  defp anagram?(base, target), do: base != target and sorted(base) == sorted(target)
  defp sorted(string), do: string |> String.to_charlist() |> Enum.sort()
end
