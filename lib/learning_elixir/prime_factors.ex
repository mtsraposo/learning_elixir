defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(1), do: []

  def factors_for(number) do
    2..number
    |> Enum.reduce_while({number, []}, &do_factor/2)
    |> return_primes()
  end

  defp do_factor(f, {rest, primes}) do
    rest
    |> factor_by(f)
    |> accumulate(rest, primes)
  end

  defp factor_by(n, f) do
    max_factor_exponent = ceil(:math.log(n) / :math.log(f))
    1..max_factor_exponent
    |> Enum.reduce_while({n, []}, fn _exp, {rest, factors} -> divide(rest, f, factors) end)
  end

  defp divide(rest, factor, factors)
       when rem(rest, factor) == 0 do
    {:cont, {div(rest, factor), [factor | factors]}}
  end

  defp divide(rest, _factor, factors) do
    {:halt, {rest, factors}}
  end

  defp accumulate({_factored, []}, rest, primes) do
    {:cont, {rest, primes}}
  end

  defp accumulate({1, factors}, _rest, primes) do
    {:halt, {1, [factors | primes]}}
  end

  defp accumulate({factored, factors}, _rest, primes) do
    {:cont, {factored, [factors | primes]}}
  end

  defp return_primes({1, primes}) do
    primes
    |> List.flatten()
    |> Enum.sort()
  end

end
