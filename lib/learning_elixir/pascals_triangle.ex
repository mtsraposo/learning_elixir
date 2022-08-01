defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(1), do: [[1]]
  def rows(2), do: [[1], [1, 1]]
  def rows(num) do
    3..num
    |> Enum.reduce(Enum.reverse(rows(2)), &pascal/2)
    |> Enum.reverse()
  end

  defp pascal(_n, [previous_row | _tail] = triangle) do
    previous_row
    |> Enum.reduce({[], 0}, &gen_row/2)
    |> add_border()
    |> Enum.reverse()
    |> merge_into(triangle)
  end

  defp gen_row(1, {[], 0}), do: {[1], 1}
  defp gen_row(prev_row_curr_n, {row, prev_row_prev_n}) do
    {[prev_row_curr_n + prev_row_prev_n | row], prev_row_curr_n}
  end

  defp add_border({row, _prev_row_last_n}) do
    [1 | row]
  end

  defp merge_into(row, triangle) do
    [row | triangle]
  end
end
