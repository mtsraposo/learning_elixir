defmodule Prime do
  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count > 0, do: gen_primes(count - 1, 3, [2])

  defp gen_primes(0, _n, primes), do: primes |> hd()
  defp gen_primes(count, n, primes) do
    if n |> is_prime?(primes) do
      gen_primes(count - 1, n + 1, [n | primes])
    else
      gen_primes(count, n + 1, primes)
    end
  end

  defp is_prime?(n, primes) do
    Enum.find(primes, &(rem(n, &1) == 0)) == nil
  end

end
