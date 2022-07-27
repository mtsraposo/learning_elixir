defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(digits, input_base, output_base) when output_base < 2, do: {:error, "output base must be >= 2"}
  def convert(digits, input_base, output_base) when input_base < 2, do: {:error, "input base must be >= 2"}
  def convert(digits, input_base, output_base) do
    if valid_digits?(digits, input_base) do
      {:ok, do_convert(digits, input_base, output_base)}
    else
      {:error, "all digits must be >= 0 and < input base"}
    end
  end

  defp valid_digits?(digits, input_base), do: Enum.find(digits, &(&1 < 0 or &1 >= input_base)) == nil
  defp do_convert(digits, input_base, output_base) do
    digits
    |> to_base10(input_base, 0)
    |> from_base10(output_base, [])
  end

  defp to_base10([], _base, []), do: [0]
  defp to_base10([], _base, acc), do: acc
  defp to_base10(digits, 10, _acc), do: Integer.undigits(digits)
  defp to_base10([digit | tail], base, acc), do: to_base10(tail, base, acc * base + digit)

  defp from_base10(0, _base, []), do: [0]
  defp from_base10(0, _base, acc), do: acc
  defp from_base10(n, 10, _acc), do: Integer.digits(n)
  defp from_base10(n, base, acc), do: from_base10(div(n, base), base, [rem(n, base) | acc])

end