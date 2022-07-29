defmodule RotationalCipher do
  @lowercase ?a..?z
  @uppercase ?A..?Z
  @alphabet_size ?z - ?a + 1

  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift)
      when is_binary(text) do
    text
    |> String.to_charlist()
    |> Enum.map(&rotate(&1, shift))
    |> List.to_string()
  end

  def rotate(char, shift)
      when char in @lowercase do
    rotate(char, shift, ?a)
  end

  def rotate(char, shift)
      when char in @uppercase do
    rotate(char, shift, ?A)
  end

  def rotate(char, shift, offset) do
    offset + rem(char + shift - offset, @alphabet_size)
  end

  def rotate(char, _shift), do: char

end
