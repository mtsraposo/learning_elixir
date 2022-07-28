defmodule ArmstrongNumber do
  @moduledoc """
  Provides a way to validate whether or not a number is an Armstrong number
  """

  @spec valid?(integer) :: boolean
  def valid?(number) do
    digits = number |> Integer.digits()
    digits |> exponentiate() |> Enum.sum() |> trunc() == number
  end
  defp exponentiate(digits) do
    n = Enum.count(digits)
    Stream.map(digits, &(:math.pow(&1, n)))
  end
end
