defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare([], []), do: :equal
  def compare([], _b), do: :sublist
  def compare(_a, []), do: :superlist

  def compare(a, b)
      when length(a) > length(b) do
    if a |> contains?(b), do: :superlist, else: :unequal
  end

  def compare(a, b)
      when length(a) == length(b) do
    if a |> contains?(b), do: :equal, else: :unequal
  end

  def compare(a, b)
      when length(a) < length(b) do
    if b |> contains?(a), do: :sublist, else: :unequal
  end

  defp contains?([], _b), do: false
  defp contains?(a, b), do: List.starts_with?(a, b) || contains?(tl(a), b)

end
