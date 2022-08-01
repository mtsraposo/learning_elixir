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
    1..number
    |> Enum.reduce_while({number, [2]}, fn _, acc -> do_factor(acc) end)
  end

  def do_factor({1, factors}) do
    {:halt, return(factors)}
  end

  def do_factor({rest, [2]})
      when rem(rest, 2) == 0 do
    {:cont, {div(rest, 2), [2, 2]}}
  end

  def do_factor({rest, [potential_factor | _tail] = factors})
      when potential_factor > rest do
    {:halt, return(factors)}
  end

  def do_factor({rest, [potential_factor | _tail] = factors})
      when rem(rest, potential_factor) == 0 do
    {:cont, {div(rest, potential_factor), [potential_factor | factors]}}
  end

  def do_factor({rest, [potential_factor | tail]}) do
    {:cont, {rest, [potential_factor + 1 | tail]}}
  end

  defp return(factors) do
    factors
    |> Enum.drop(1)
    |> Enum.reverse()
  end

end
