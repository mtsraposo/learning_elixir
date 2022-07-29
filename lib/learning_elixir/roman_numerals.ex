defmodule RomanNumerals do
  @exponent_to_unit %{
    0 => "I",
    1 => "X",
    2 => "C",
    3 => "M"
  }
  @exponent_to_half %{
    1 => "V",
    2 => "L",
    3 => "D"
  }

  @doc """
  Convert the number to a roman number.
  """
  @spec numeral(pos_integer) :: String.t()
  def numeral(number) do
    number
    |> Integer.digits()
    |> Enum.reverse()
    |> Stream.with_index()
    |> Stream.map(&to_roman/1)
    |> Enum.reverse()
    |> Enum.join()
  end

  def to_roman({9, exponent}) do
    "#{Map.get(@exponent_to_unit, exponent)}#{Map.get(@exponent_to_unit, exponent + 1)}"
  end

  def to_roman({digit, exponent})
      when digit > 5 do
    "#{to_roman({5, exponent})}#{to_roman({digit - 5, exponent})}"
  end

  def to_roman({5, exponent}) do
    Map.get(@exponent_to_half, exponent + 1)
  end

  def to_roman({4, exponent}) do
    "#{Map.get(@exponent_to_unit, exponent)}#{Map.get(@exponent_to_half, exponent + 1)}"
  end

  def to_roman({digit, exponent}) do
    Map.get(@exponent_to_unit, exponent)
    |> String.duplicate(digit)
  end

end
