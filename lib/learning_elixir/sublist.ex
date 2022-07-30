defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare([], []), do: :equal
  def compare([], _b), do: :sublist
  def compare(_a, []), do: :superlist

  def compare(a, b)
      when length(a) == length(b) do
    do_compare({a, length(a)}, {b, length(b)})
    |> invert(:equal_size)
  end

  def compare(a,b)
      when length(a) > length(b) do
    do_compare({a, length(a)}, {b, length(b)})
    |> invert(:larger)
  end

  def compare(a,b) do
    do_compare({b, length(b)}, {a, length(a)})
  end

  def invert(:sublist, :equal_size), do: :equal
  def invert(:sublist, :larger), do: :superlist
  def invert(relation, _size_comparison), do: relation

  defp do_compare({large, size_large}, {small, size_small}) do
    index = Enum.find_index(large, fn elem -> elem === hd(small) end)
    case index do
      0 -> traverse(index, {large, size_large}, {small, size_small})
      nil -> :unequal
      _ -> do_compare({Enum.slice(large, index..-1), size_large}, {small, size_small})
    end
  end

  defp traverse(index, {large, size_large}, {small, size_small}) do
    if contained?({large, size_large}, {small, size_small}) do
      :sublist
    else
      do_compare({Enum.slice(large, index+1..-1), size_large}, {small, size_small})
    end
  end

  defp contained?({large, _size_large}, {small, size_small}) do
    intersection_count = Enum.count_until(Enum.zip(large,small),
      fn {elem_large, elem_small} -> elem_large === elem_small end,
      size_small)
    intersection_count == size_small
  end

end
