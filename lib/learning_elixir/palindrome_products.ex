defmodule PalindromeProducts do
  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1)
  def generate(max_factor, min_factor) when max_factor < min_factor, do: raise ArgumentError

  def generate(max_factor, min_factor) do
    %{}
    |> find_palindrome_product(min_factor, max_factor)
    |> find_palindrome_product(max_factor, min_factor)
    |> expand_factors(max_factor, min_factor)
  end

  defp find_palindrome_product(result, start, stop) do
    step = calc_step(start, stop)
    get_first_palindrome(start, step)
    |> Stream.iterate(&next_palindrome(&1, step))
    |> Enum.find_value(fn palindrome -> palindrome |> factors_in_range?(start, stop, step) end)
    |> Map.new() |> Map.merge(result)
  end

  defp calc_step(start, stop), do: if(start < stop, do: 1, else: -1)

  defp get_first_palindrome(start, step) do
    if is_palindrome?(start ** 2),
       do: start ** 2,
       else: next_palindrome(start ** 2, step)
  end

  defp is_palindrome?(n) do
    digits = Integer.digits(n)
    digits == Enum.reverse(digits)
  end

  defp next_palindrome(n, step \\ 1)
  defp next_palindrome(n, step) do
    n
    |> split()
    |> mirror(exponent(n))
    |> to_next(n, step)
  end

  defp exponent(0), do: 0
  defp exponent(n), do: floor(:math.log10(n)) + 1

  defp split(n) do
    exp = exponent(n)
    Integer.digits(n)
    |> Enum.take(ceil(exp / 2))
    |> Integer.undigits()
  end

  defp mirror({half, exp}), do: mirror(half, exp)
  defp mirror(half, exp) do
    Integer.digits(half)
    |> (& &1 ++ Enum.reverse(Enum.drop(&1, -rem(exp, 2)))).()
    |> Integer.undigits()
  end

  defp to_next(palindrome, n, step) do
    if next?(palindrome, n, step),
       do: palindrome,
       else: update_and_mirror(n, step)
  end

  defp next?(x, y, 1), do: x > y
  defp next?(x, y, -1), do: x < y

  defp update_and_mirror(n, step) do
    split(n)
    |> update_exp(n, step)
    |> update_half(n, step)
    |> mirror()
  end

  defp update_exp(half, n, step) do
    {half, exponent(n) + exponent(half + step) - exponent(half)}
  end

  defp update_half({half, exp}, n, 1) do
    if exp > exponent(n) and rem(exp, 2) == 0,
       do: {split(half + 1), exp},
       else: {half + 1, exp}
  end

  defp update_half({half, exp}, n, -1) do
    if half |> is_power_of_ten?(),
       do: downscale(half, exp),
       else: {half - 1, exp}
  end

  defp downscale(half, exp) do
    if rem(exp, 2) == 0,
       do: {10 ** exponent(half - 1) - 1, exp},
       else: {10 ** exponent(half) - 1, exp}
  end

  defp is_power_of_ten?(half) do
    ceil(:math.log10(half)) == :math.log10(half)
  end

  defp factors_in_range?(palindrome, start, stop, 1)
       when palindrome >= stop * stop do
    []
  end

  defp factors_in_range?(palindrome, start, stop, -1)
       when palindrome <= stop * stop do
    []
  end

  defp factors_in_range?(palindrome, start, stop, step) do
    search_range(palindrome, start, stop, step)
    |> Enum.find(&(rem(palindrome, &1) == 0))
    |> return_palindrome_and_factors_if_found(palindrome)
  end

  defp search_range(palindrome, start, stop, 1), do: search_range(palindrome, start, stop)
  defp search_range(palindrome, start, stop, -1), do: search_range(palindrome, stop, start)

  defp search_range(palindrome, start, stop) do
    Range.new(max(start, ceil(palindrome / stop)),
      min(stop, floor(palindrome / start)),
      1)
  end

  defp return_palindrome_and_factors_if_found(n, palindrome) do
    n && [{palindrome, [Enum.sort([div(palindrome, n), n])]}]
  end

  defp expand_factors(result, max_factor, min_factor)
       when is_map(result) do
    result
    |> Enum.map(fn {product, [factors]} -> {product, [factors | expand_factors(factors, max_factor, min_factor)]} end)
    |> Map.new()
  end

  defp expand_factors([low, high], max_factor, min_factor) do
    factor_search_range(low, high, max_factor, min_factor)
    |> Enum.filter(fn n -> rem(high, n) == 0 end)
    |> Enum.map(fn n -> Enum.sort([low * n, div(high, n)]) end)
  end

  defp factor_search_range(low, high, max_factor, min_factor) do
    div(max_factor, low)
    |> min(div(high, min_factor))
    |> min(high - 1)
    |> (&Range.new(2, &1, 1)).()
  end
end