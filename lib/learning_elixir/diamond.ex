defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t()
  def build_shape(letter) do
    letter
    |> calc_size()
    |> gen_first_quadrant()
    |> mirror_y_axis()
    |> mirror_x_axis()
    |> join()
  end

  defp calc_size(letter) do
    2*(letter - ?A) + 1
  end

  defp gen_first_quadrant(size) do
    0..div(size, 2)
    |> Enum.map(&gen_row(&1, size))
  end

  defp gen_row(n, size) do
    "~*.1c"
    |> :io_lib.format(padding_and_letter(n, size))
    |> List.to_string()
    |> String.pad_trailing(div(size, 2) + 1)
    |> String.graphemes()
  end

  defp padding_and_letter(n, size) do
    left_padding = div(size, 2) - n
    letter = ?A + n
    [left_padding + 1, letter]
  end

  defp mirror_y_axis(quadrant) do
    quadrant
    |> Enum.map(&mirror/1)
  end

  defp mirror_x_axis(half) do
    mirror(half)
  end

  defp mirror(enum) do
    Enum.concat(enum,
      enum |> Enum.drop(-1) |> Enum.reverse())
  end

  defp join(diamond) do
    diamond
    |> Enum.map(fn row -> Enum.join(row) <> "\n" end)
    |> Enum.join()
  end
end
