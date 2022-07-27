defmodule AllYourBase do
  @doc """
  Given a number in input base, represented as a sequence of digits, converts it to output base,
  or returns an error tuple if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: {:ok, list} | {:error, String.t()}
  def convert(digits, input_base, output_base) do
    cond do
      output_base < 2 -> {:error, "output base must be >= 2"}
      input_base < 2 -> {:error, "input base must be >= 2"}
      not valid_digits?(digits, input_base) -> {:error, "all digits must be >= 0 and < input base"}
      true -> {:ok, convert(digits, input_base, output_base, true)}
    end
  end
  defp convert(digits, input_base, output_base, true) do
    digits
    |> convert_to_base10(input_base, Enum.count(digits), 0)
    |> convert_from_base10(output_base, [0])
  end
  defp valid_digits?(digits, input_base) do
    Enum.filter(digits, fn d -> d < 0 or d >= input_base end) == []
  end

  defp convert_to_base10(digits, input_base, 0, acc), do: acc
  defp convert_to_base10(digits, 10, length, acc), do: Integer.undigits(digits)
  defp convert_to_base10([digit | tail], input_base, length, acc) do
    new_acc = acc + trunc(digit * :math.pow(input_base, length - 1))
    convert_to_base10(tail, input_base, length - 1, new_acc)
  end

  defp convert_from_base10(0, output_base, acc), do: Enum.reverse(acc)
  defp convert_from_base10(n, 10, acc), do: Integer.digits(n)
  defp convert_from_base10(n, output_base, acc) do
    exp = :math.log(n) / :math.log(output_base) |> trunc()
    rest = n - :math.pow(output_base, exp) |> trunc()
    digit = 1 + (rest / :math.pow(output_base, exp) |> trunc())
    next_n = n - digit * :math.pow(output_base, exp) |> trunc()
    new_acc = accumulate(exp, digit, acc)
    convert_from_base10(next_n, output_base, new_acc)
  end

  defp accumulate(0, digit, [0]), do: [digit]
  defp accumulate(exp, digit, [0]) do
    initialize = for _ <- 0..exp-1, do: 0
    initialize ++ [digit]
  end
  defp accumulate(exp, digit, acc), do: List.replace_at(acc, exp, digit)

end
