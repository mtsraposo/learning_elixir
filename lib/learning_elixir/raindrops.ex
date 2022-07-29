defmodule Raindrops do
  @raindrop_sounds %{
    3 => "Pling",
    5 => "Plang",
    7 => "Plong"
  }

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    [3,5,7]
    |> Enum.filter(&(rem(number, &1) == 0))
    |> convert_factors(number)
  end

  defp convert_factors([], number) do
    Integer.to_string(number)
  end

  defp convert_factors(factors, _number) do
    factors
    |> Enum.map_join(&Map.get(@raindrop_sounds, &1))
  end

end
