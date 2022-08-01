defmodule Matrix do
  defstruct matrix: nil

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    input
    |> preprocess()
    |> parse()
  end

  defp preprocess(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.split/1)
  end

  defp parse(input) do
    %{rows: parse_rows(input), cols: parse_cols(input)}
  end

  defp parse_rows(input) do
    input
    |> Stream.with_index()
    |> Enum.map(fn {row, index} -> {index, row |> to_integer()} end)
    |> Map.new()
  end

  defp parse_cols(input) do
    input
    |> enumerate_cols()
    |> map_rows()
    |> rows_to_cols()
    |> Map.new()
  end

  defp enumerate_cols(input) do
    input
    |> Stream.map(&Stream.with_index/1)
  end

  defp map_rows(enumerated) do
    enumerated
    |> prepare_for_map()
    |> Stream.map(&Map.new/1)
  end

  defp prepare_for_map(enumerated_cols) do
    enumerated_cols
    |> Stream.map(&invert_index/1)
    |> Stream.map(&col_to_integer/1)
    |> Stream.map(&initialize_col/1)
  end

  defp invert_index(enumerated_cols) do
    enumerated_cols
    |> Stream.map(fn {elem, index} -> {index, elem} end)
  end

  defp col_to_integer(inverted) do
    inverted
    |> Stream.map(fn {index, elem} -> {index, elem |> to_integer()} end)
  end

  defp initialize_col(integer_matrix) do
    integer_matrix
    |> Stream.map(fn {index, elem} -> {index, [elem]} end)
  end

  defp rows_to_cols(mapped_rows) do
    mapped_rows
    |> Enum.reduce(%{}, fn row, cols -> Map.merge(cols, row, &append_if_exists/3) end)
    |> Enum.map(fn {index, col} -> {index, Enum.reverse(col)} end)
  end

  defp append_if_exists(_index, col, [elem]) do
    [elem | col]
  end

  defp to_integer(row)
       when is_list(row) do
    row |> Enum.map(&to_integer/1)
  end

  defp to_integer(elem) do
    String.to_integer(elem)
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(matrix) do
    matrix.rows
    |> Enum.reduce("", &concat_row/2)
    |> String.trim()
  end

  defp concat_row({index, row}, str) do
    "#{str}#{Enum.join(row, " ")}\n"
  end

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(matrix) do
    Map.values(matrix.rows)
  end

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(matrix, index) do
    matrix.rows[index-1]
  end

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(matrix) do
    Map.values(matrix.cols)
  end

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index) do
    matrix.cols[index-1]
  end
end
