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
    |> Enum.zip_with(& &1)
  end

  defp to_message(transposed) do
    transposed
    |> Enum.reduce("", &concat_col/2)
    |> String.trim_leading()
  end

  defp concat_col(col, str) do
    "#{str} #{col |> Enum.join()}"
  end
end
