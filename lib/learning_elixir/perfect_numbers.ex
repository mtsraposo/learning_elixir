defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: {:ok, atom} | {:error, String.t()}
  def classify(number)
      when number <= 0 do
    {:error, "Classification is only possible for natural numbers."}
  end

  def classify(number) do
    {:ok, do_classify(number)}
  end

  defp do_classify(1), do: :deficient

  defp do_classify(number) do
    number
    |> factor()
    |> Enum.sum()
    |> do_classify(number)
  end

  defp factor(number) do
    1..(number - 1)
    |> Enum.filter(& rem(number, &1) == 0)
  end

  defp do_classify(aliquot_sum, number)
       when aliquot_sum == number do
    :perfect
  end

  defp do_classify(aliquot_sum, number)
       when aliquot_sum > number do
    :abundant
  end

  defp do_classify(aliquot_sum, number)
       when aliquot_sum < number do
    :deficient
  end
end
