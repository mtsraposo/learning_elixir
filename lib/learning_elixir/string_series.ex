defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(s, size) do
    sequences_of_size_unicode_alphanumerics = ~r"\w(?=(\w{#{size - 1}}))"u
    Regex.scan(sequences_of_size_unicode_alphanumerics, s)
    |> Enum.map(&Enum.join/1)
  end
end
