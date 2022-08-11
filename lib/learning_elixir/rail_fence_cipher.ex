defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t(), pos_integer) :: String.t()
  def encode("", rails), do: ""
  def encode(str, 1), do: str
  def encode(str, rails) when byte_size(str) <= rails, do: str
  def encode(str, rails) do
    1..rails
    |> Enum.map(& gen_positions(str, &1, rails))
    |> Enum.map(& encode_row(str, &1))
    |> Enum.join()
  end

  defp gen_positions(str, row_number, rails) do
    str
    |> calc_chars_in_row(row_number, rails)
    |> get_char_positions(row_number, rails)
  end

  defp calc_chars_in_row(str, row_number, rails)
       when row_number > 1 and row_number < rails do
    1 + 2 * div(byte_size(str) - row_number, 2 * (rails - 1)) + last_cycle(str, row_number, rails)
  end

  defp calc_chars_in_row(str, 1, rails) do
    1 + div(byte_size(str) - 1, 2 * (rails - 1))
  end

  defp calc_chars_in_row(str, rails, rails) do
    1 + div(byte_size(str) - rails, 2 * (rails - 1))
  end

  defp last_cycle(str, row_number, rails) do
    if rem(byte_size(str) - row_number, 2 * (rails - 1)) >= 2*(rails - 1) - row_number,
       do: 1,
       else: 0
  end

  defp get_char_positions(chars_in_row, row_number, rails) do
    Range.new(2, chars_in_row, 1)
    |> Enum.reduce([row_number - 1], &append_next_position(&1, &2, row_number, rails))
    |> Enum.reverse()
  end

  defp append_next_position(index, [last_pos | _] = positions, row_number, rails) do
    [calc_next_position(index, last_pos, row_number, rails) | positions]
  end

  defp calc_next_position(index, last_pos, row_number, rails)
       when row_number > 1 and row_number < rails do
    if rem(index, 2) == 0,
       do: last_pos + 2 * (rails - row_number),
       else: last_pos + 2 * (row_number - 1)
  end

  defp calc_next_position(index, last_pos, row_number, rails) do
    last_pos + 2 * (rails - 1)
  end

  defp encode_row(str, positions) do
    positions
    |> Enum.map(&binary_part(str, &1, 1))
    |> Enum.join()
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t(), pos_integer) :: String.t()
  def decode("", rails), do: ""
  def decode(str, 1), do: str
  def decode(str, rails) when byte_size(str) < rails, do: str
  def decode(str, rails) do
    1..rails
    |> Enum.map(& gen_positions(str, &1, rails))
    |> List.flatten()
    |> map_positions(str)
  end

  defp map_positions(positions, str) do
    positions
    |> Enum.zip(String.graphemes(str))
    |> Enum.sort()
    |> Enum.reduce("", fn {_, char}, decoded -> decoded <> char end)
  end
end
