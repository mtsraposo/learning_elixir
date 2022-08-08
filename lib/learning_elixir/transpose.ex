defmodule Transpose do
  @doc """
  Given an input text, output it transposed.

  Rows become columns and columns become rows. See https://en.wikipedia.org/wiki/Transpose.

  If the input has rows of different lengths, this is to be solved as follows:
    * Pad to the left with spaces.
    * Don't pad to the right.

  ## Examples

    iex> Transpose.transpose("ABC\\nDE")
    "AD\\nBE\\nC"

    iex> Transpose.transpose("AB\\nDEF")
    "AD\\nBE\\n F"
  """

  @spec transpose(String.t()) :: String.t()
  def transpose(input)
      when is_binary(input) do
    input
    |> to_rows()
    |> pad_rows()
    |> transpose()
    |> join()
  end

  def transpose(square_matrix) do
    square_matrix
    |> Enum.zip_with(&(&1))
  end

  defp to_rows(input) do
    String.split(input, "\n")
  end

  defp pad_rows(rows) do
    with_padding = [{first_row, matrix_width} | _] = calc_padding(rows)
    with_padding
    |> Stream.map(&pad(&1, matrix_width))
  end

  defp calc_padding(rows) do
    rows
    |> Enum.reverse()
    |> Enum.reduce([], &calc_padding/2)
  end

  defp calc_padding(row, []), do: [{row, String.length(row)}]

  defp calc_padding(row, [{_, last_padding} | _] = rows_with_padding) do
    [{row, max(String.length(row), last_padding)} | rows_with_padding]
  end

  defp pad({row, padding}, matrix_width) do
    row
    |> String.pad_trailing(padding)
    |> String.graphemes()
    |> fill(matrix_width, padding)
  end

  defp fill(row, matrix_width, padding) do
    row ++ List.duplicate("", matrix_width - padding)
  end

  defp join(transposed) do
    transposed
    |> Stream.map(&Enum.join(&1))
    |> Enum.join("\n")
  end
end

