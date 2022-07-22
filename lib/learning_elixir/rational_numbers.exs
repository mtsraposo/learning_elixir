defmodule RationalNumbers do
  @type rational :: {integer, integer}

  @doc """
  Add two rational numbers
  """
  @spec add(a :: rational, b :: rational) :: rational
  def add({a1, b1}, {a2, b2}) do {(a1 * b2 + a2 * b1), (b1 * b2)} |> reduce() end

  @doc """
  Subtract two rational numbers
  """
  @spec subtract(a :: rational, b :: rational) :: rational
  def subtract({a1, b1}, {a2, b2}) do {(a1 * b2 - a2 * b1), (b1 * b2)} |> reduce() end

  @doc """
  Multiply two rational numbers
  """
  @spec multiply(a :: rational, b :: rational) :: rational
  def multiply({a1, b1}, {a2, b2}) do {(a1 * a2), (b1 * b2)} |> reduce() end

  @doc """
  Divide two rational numbers
  """
  @spec divide_by(num :: rational, den :: rational) :: rational
  def divide_by({a1, b1}, {a2, b2}) do {(a1 * b2), (b1 * a2)} |> reduce() end

  @doc """
  Absolute value of a rational number
  """
  @spec abs(a :: rational) :: rational
  def abs({num, den}) do {Kernel.abs(num), Kernel.abs(den)} |> reduce() end

  @doc """
  Exponentiation of a rational number by an integer
  """
  @spec pow_rational(a :: rational, n :: integer) :: rational
  def pow_rational({num, den}, n) when n >= 0 do
    {:math.pow(num, n) |> trunc(),
      :math.pow(den, n) |> trunc()}
    |> reduce()
  end
  def pow_rational({num, den}, n) when n < 0 do
    m = Kernel.abs(n)
    {:math.pow(den, m) |> trunc(),
      :math.pow(num, m) |> trunc()}
    |> reduce()
  end

  @doc """
  Exponentiation of a real number by a rational number
  """
  @spec pow_real(x :: integer, n :: rational) :: float
  def pow_real(x, {num, den}) do :math.pow(:math.pow(x, num), 1 / den) end

  def gcd(x,y) do
    lowest = min(x,y)
    cond do
      lowest == 0 -> max(x,y)
      true -> for n <- 1..lowest, reduce: 1 do
                result -> max(result,
                            cond do
                              rem(x, n) == 0 and rem(y, n) == 0 -> n
                              true -> result
                            end)
              end
    end
  end

  @doc """
  Reduce a rational number to its lowest terms
  """
  @spec reduce(a :: rational) :: rational
  def reduce({num, den}) do
    divide_by = gcd(Kernel.abs(num), Kernel.abs(den))
    {r_num, r_den} = cond do
      num < 0 and den < 0 -> {Kernel.abs(num) / divide_by,
                               Kernel.abs(den) / divide_by}
      num > 0 and den < 0 -> {-1 * num / divide_by,
                               Kernel.abs(den) / divide_by}
      num == 0 and den == 0 -> :error
      true -> {num / divide_by,
                den / divide_by}
    end
    {r_num |> trunc(), r_den |> trunc()}
  end
end
