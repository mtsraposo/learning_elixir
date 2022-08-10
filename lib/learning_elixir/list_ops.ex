defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count([]), do: 0
  def count([head | tail]) do
    1 + count(tail)
  end

  @spec reverse(list) :: list
  def reverse([]), do: []
  def reverse([head | tail]) do
    move_to_end(head, reverse(tail))
  end

  defp move_to_end(a, []), do: [a]
  defp move_to_end(a, [head | tail]) do
    [head | move_to_end(a, tail)]
  end

  @spec map(list, (any -> any)) :: list
  def map([], f), do: []
  def map([head | tail], f) do
    [f.(head) | map(tail, f)]
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([], f), do: []
  def filter([head | tail], f) do
    if f.(head),
       do: [head | filter(tail, f)],
       else: filter(tail, f)
  end

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl([], acc, f), do: acc
  def foldl([head | tail], acc, f) do
    foldl(tail, f.(head, acc), f)
  end

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr([], acc, f), do: acc
  def foldr(l, acc, f) do
    reverse(l)
    |> foldl(acc, f)
  end

  @spec append(list, list) :: list
  def append([], b), do: b
  def append(a, []), do: a
  def append([head_a | tail_a], b) do
    [head_a | append(tail_a, b)]
  end

  @spec concat([[any]]) :: [any]
  def concat([]), do: []

  def concat([[] | tail_l]) do
    concat(tail_l)
  end

  def concat([[h | t] | tail_l]) do
    [h | concat([t | tail_l])]
  end
end
