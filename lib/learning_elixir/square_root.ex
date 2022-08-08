defmodule SquareRoot do
  @doc """
  Calculate the integer square root of a positive integer
  """
  @spec calculate(radicand :: pos_integer) :: pos_integer
  def calculate(radicand) do
    search_root(radicand, 1, radicand)
  end

  defp search_root(radicand, start, stop)
       when start > stop do
    :not_square
  end

  defp search_root(radicand, start, stop) do
    midpoint = div(start + stop, 2)
    midsquare = midpoint * midpoint
    cond do
      midsquare == radicand -> midpoint
      midsquare > radicand -> search_root(radicand, start, midpoint - 1)
      midsquare < radicand -> search_root(radicand, midpoint + 1, stop)
    end
  end
end
