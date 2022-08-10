defmodule Knapsack do
  @doc """
  Return the maximum value that a knapsack can carry.
  """
  @spec maximum_value(items :: [%{value: integer, weight: integer}], maximum_weight :: integer) ::
          integer
  def maximum_value([], _), do: 0

  def maximum_value(items, maximum_weight) do
    items = to_map(items)
    1..maximum_weight
    |> Enum.reduce(%{}, &append_row(&1, &2, items))
    |> return_value(maximum_weight, map_size(items))
  end

  defp to_map(items) do
    items
    |> Enum.with_index(fn item, index -> {index + 1, item} end)
    |> Map.new()
  end

  defp append_row(size_limit, matrix, items) do
    Map.put(matrix, size_limit, maximize_row(size_limit, matrix, items))
  end

  defp maximize_row(size_limit, matrix, items) do
    1..map_size(items)
    |> Enum.reduce(%{}, &Map.put(&2, &1, maximize_item(&1, &2, size_limit, matrix, items)))
  end

  defp maximize_item(index, row, size_limit, matrix, items) do
    %{value: v, weight: w} = item = items[index]
    if index == 1,
       do: item_or_not({v, w}, size_limit),
       else: get_previous(matrix, row, index, size_limit, w)
             |> local_max(index, {v, w}, size_limit)
  end

  defp item_or_not({v, w}, size_limit) do
    if w <= size_limit,
       do: {v, w},
       else: {0, 0}
  end

  defp get_previous(matrix, row, index, size_limit, w) do
    {row[index - 1], matrix[size_limit - w][index - 1]}
  end

  defp local_max({prev_row, complement}, index, {v, w}, size_limit) do
    [
      item_or_not({v, w}, size_limit),
      with_item(index, {v, w}, complement),
      prev_row
    ]
    |> Enum.max(fn {v1, w1}, {v2, w2} -> v1 > v2 end)
  end

  defp with_item(_, _, nil), do: {0, 0}

  defp with_item(index, {v, w}, {acc_v, acc_w}) do
    {acc_v + v, acc_w + w}
  end

  defp return_value(dp_matrix, maximum_weight, n) do
    {v, _} = dp_matrix
             |> Map.get(maximum_weight)
             |> Map.get(n)
    v
  end

end
