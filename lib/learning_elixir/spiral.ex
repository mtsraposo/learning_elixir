defmodule Spiral do
  @doc """
  Given the dimension, return a square matrix of numbers in clockwise spiral order.
  """
  @spec matrix(dimension :: integer) :: list(list(integer))
  def matrix(0), do: []
  def matrix(1), do: [[1]]

  def matrix(dimension = n) do
    gen_top_and_bottom_rows(n)
    |> wrap_around_core(n)
    |> flatten(n)
  end

  defp gen_top_and_bottom_rows(n) do
    [Enum.to_list(1..n),
      Enum.to_list((3*n-2)..(2*n-1))]
  end

  defp wrap_around_core([top_row, bottom_row], n) do
    core = matrix(n - 2) |> with_column_layers(n)
    [top_row, core, bottom_row]
  end

  defp with_column_layers(matrix, n) do
    matrix
    |> Enum.map(&scale_to_outer_dimension(&1, n))
    |> Enum.with_index()
    |> Enum.map(&layer(&1, n))
  end

  defp scale_to_outer_dimension(row, n) do
    Enum.map(row, &Kernel.+(&1, 4 * n - 4))
  end

  defp layer({row, index}, n) do
    [4 * n - 4 - index, row, n + 1 + index]
  end

  defp flatten(matrix, n) do
    matrix
    |> List.flatten()
    |> Enum.chunk_every(n)
  end
end
