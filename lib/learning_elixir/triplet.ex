defmodule Triplet do
  @moduledoc ~S"""
  To run in O(sum), it is necessary to reduce the problem by using some algebra.

  Using "s" to denote the sum of the triplet and assuming s > 0,
  we solve the system of equations:
    [
     {a**2 + b**2 == c**2},
     {a + b + c == s}
    ]
  , which yields:
    (i) a = (s**2 - 2*b*s) / (2*(s - b))
  The boundary conditions 0 < a < b < c yield the system of equations:
    (ii) [
     {(s**2 - 2*b*s > 0 and 2*(s - b) > 0)
      or (s**2 - 2*b*s < 0 and 2*(s - b) < 0)},
     {(s**2 - 2*b*s) / (2*(s - b)) > a}
    ]
  , which yields:
    (iii) [
      {b < s / 2 or b > s},
      {b > (1 - sqrt(2) / 2) * s and b < (1 + sqrt(2) / 2)}
    ]
  , which reduces to:
    (iv) [
      {b > (1 - sqrt(2) / 2) * s},
      {b < min(s / 2, (1 + sqrt(2) / 2))}
    ]
  For all "b"s within this range and for which:
    (v) a (given by equation (i)) is integer,
  we have a triplet:
    (vi) [
     (s**2 - 2*b*s) / (2*(s - b)),
     b,
     s - (s**2 - 2*b*s) / (2*(s - b)) - b
    ]
  """

  @doc """
  Calculates sum of a given triplet of integers.
  """
  @spec sum([non_neg_integer]) :: non_neg_integer
  def sum(triplet) do
    Enum.sum(triplet)
  end

  @doc """
  Calculates product of a given triplet of integers.
  """
  @spec product([non_neg_integer]) :: non_neg_integer
  def product(triplet) do
    Enum.product(triplet)
  end

  @doc """
  Determines if a given triplet is pythagorean. That is, do the squares of a and b add up to the square of c?
  """
  @spec pythagorean?([non_neg_integer]) :: boolean
  def pythagorean?([a, b, c]) do
    a**2 + b**2 == c**2
  end

  @doc """
  Generates a list of pythagorean triplets whose values add up to a given sum.
  """
  @spec generate(non_neg_integer) :: [list(non_neg_integer)]
  def generate(sum) do
    sum
    |> gen_search_range_for_b()
    |> Enum.filter(&a_is_integer?(&1, sum))
    |> Enum.map(&gen_triplet(&1, sum))
    |> Enum.sort()
  end

  defp gen_search_range_for_b(sum) do
    Range.new(ceil((1 - (2**0.5)/2) * sum),
      min(div(sum, 2) - 1, floor((1 + (2**0.5)/2) * sum)))
  end

  defp a_is_integer?(b, sum) do
    rem(sum ** 2 - 2 * b * sum, 2 * (sum - b)) == 0
  end

  defp gen_triplet(b, sum) do
    a = div(sum**2 - 2 * b * sum, 2 * (sum - b))
    c = sum - a - b
    [a, b, c]
  end
end
