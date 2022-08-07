defmodule Luhn do
  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    if valid_characters?(number),
       do: number |> get_digits() |> valid_sum?(),
       else: false
  end

  defp valid_characters?(number) do
    number
    |> remove_whitespace()
    |> String.match?(~r"^\d\d+$")
  end

  defp remove_whitespace(number) do
    String.replace(number, ~r/\s/, "")
  end

  defp get_digits(number) do
    number
    |> remove_whitespace()
    |> String.to_integer()
    |> Integer.digits()
  end

  defp valid_sum?(digits) do
    digits
    |> double_every_second()
    |> Enum.sum()
    |> check()
  end

  defp double_every_second(digits) do
    len = length(digits)
    digits
    |> Stream.with_index()
    |> Stream.map(fn {d, i} -> if(rem(len - 1 - i, 2) == 1, do: luhn_double(d), else: d) end)
  end

  defp luhn_double(digit) do
    rem(2 * digit - 1, 9) + 1
  end

  defp check(sum) do
    rem(sum, 10) == 0
  end

end
