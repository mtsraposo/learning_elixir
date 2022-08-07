defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(""), do: []

  def rows(str) do
    str
    |> String.split("\n")
    |> Stream.map(&String.split(&1))
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    transpose(rows(str))
  end

  defp transpose(matrix) do
    Enum.zip_with(matrix, &(&1))
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    str
    |> rows()
    |> index()
    |> find_extremes()
    |> match_saddle_points()
  end

  defp index(rows) do
    rows
    |> Enum.map(&Enum.with_index(&1))
    |> Enum.with_index()
  end

  defp find_extremes(indexed_rows) do
    indexed_rows
    |> Enum.reduce({%{}, %{}}, &update_extremes/2)
    |> extract_indexes()
  end

  defp update_extremes({row, row_index}, extremes) do
    row
    |> Enum.reduce(extremes, &update_extremes(&1, &2, row_index))
  end

  defp update_extremes({elem, col_index}, {max_by_row, min_by_col}, row_index) do
    {update_row(max_by_row, elem, row_index, col_index),
      update_col(min_by_col, elem, row_index, col_index)}
  end

  defp update_row(max_by_row, elem, row_index, col_index)
       when not is_map_key(max_by_row, row_index) do
    initialize_row_extremes(max_by_row, elem, row_index, col_index)
  end

  defp initialize_row_extremes(max_by_row, elem, row_index, col_index) do
    Map.put(max_by_row, row_index, {elem, %{col_index => elem}})
  end

  defp update_row(max_by_row, elem, row_index, col_index) do
    {current_max, indexes} = max_by_row[row_index]
    cond do
      elem == current_max -> Map.update!(max_by_row, row_index, &append_index(&1, col_index))
      elem > current_max -> Map.update!(max_by_row, row_index, &replace_with_index(&1, elem, col_index))
      true -> max_by_row
    end
  end

  defp append_index({current_extreme, indexes}, to_append) do
    {current_extreme, Map.put(indexes, to_append, current_extreme)}
  end

  defp replace_with_index({_, _}, elem, index) do
    {elem, %{index => elem}}
  end

  defp update_col(min_by_col, elem, row_index, col_index)
       when not is_map_key(min_by_col, col_index) do
    initialize_col_extremes(min_by_col, elem, row_index, col_index)
  end

  defp initialize_col_extremes(min_by_col, elem, row_index, col_index) do
    Map.put(min_by_col, col_index, {elem, %{row_index => elem}})
  end

  defp update_col(min_by_col, elem, row_index, col_index) do
    {current_min, indexes} = min_by_col[col_index]
    cond do
      elem == current_min -> Map.update!(min_by_col, col_index, &append_index(&1, row_index))
      elem < current_min -> Map.update!(min_by_col, col_index, &replace_with_index(&1, elem, row_index))
      true -> min_by_col
    end
  end

  defp extract_indexes({max_by_row, min_by_col}) do
    {extract_indexes(max_by_row), extract_indexes(min_by_col)}
  end

  defp extract_indexes(map) do
    map
    |> Enum.map(fn {index, {extreme, indexes}} -> {index, indexes} end)
    |> Map.new()
  end

  defp match_saddle_points({max_by_row, min_by_col}) do
    max_by_row
    |> Enum.reduce([], &match_saddle_points(&1, &2, min_by_col))
    |> Enum.sort()
  end

  defp match_saddle_points({row, col_indexes}, points, min_by_col) do
    col_indexes
    |> Enum.reduce(points, &match_point(&1, &2, row, min_by_col))
  end

  defp match_point({col, _elem}, points, row, min_by_col) do
    if min_by_col[col][row] != nil,
       do: [{row + 1, col + 1} | points],
       else: points
  end
end
