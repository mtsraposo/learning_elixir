defmodule Sieve do
  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(1), do: []

  def primes_to(limit) do
    Range.new(2, ceil(limit**0.5), 1)
    |> Enum.reduce(MapSet.new(2..limit), &remove_multiples(&1, &2, limit))
    |> MapSet.to_list()
    |> Enum.sort()
  end

  defp remove_multiples(factor, primes, limit) do
    Range.new(factor, ceil(limit / 2), 1)
    |> Enum.reduce(primes, &MapSet.delete(&2, &1 * factor))
  end
end
