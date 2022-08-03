defmodule CryptoSquare do
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t()) :: String.t()
  def encode(""), do: ""

  def encode(str) do
    str
    |> normalize()
    |> to_rectangle()
    |> transpose()
    |> to_message()
  end

  defp normalize(str) do
    str
    |> String.downcase()
    |> String.replace(~r"[^[:alnum:]]", "")
  end

  defp to_rectangle(str) do
    {c, r} = calc_dimensions(str)
    str
    |> String.graphemes()
    |> Enum.chunk_every(c, c, padding(c))
  end

  defp calc_dimensions(str) do
    str
    |> String.length()
    |> :math.sqrt()
    |> (& {ceil(&1), floor(&1)}).()
  end

  defp padding(c) do
    String.duplicate(" ", c - 1)
    |> String.graphemes()
  end

  defp transpose(matrix) do
    matrix
    |> Enum.reduce(%{}, &transpose/2)
  end

  defp transpose(row, map) do
    row
    |> Enum.with_index()
    |> Enum.reduce(map, &rows_to_cols/2)
  end

  defp rows_to_cols({elem, col_index}, acc) do
    acc
    |> Map.get_and_update(col_index, fn col -> update_map(col, elem) end)
    |> return_map()
  end

  defp update_map(nil, elem) do
    {nil, [elem]}
  end

  defp update_map(col, elem) do
    {col, [elem | col]}
  end

  defp return_map({last_col_elem, map}) do
    map
  end

  defp to_message(transposed) do
    transposed
    |> Enum.reduce("", &concat_col/2)
    |> String.trim_leading()
  end

  defp concat_col({_i, col}, str) do
    "#{str} #{col |> Enum.reverse() |> Enum.join()}"
  end
end
