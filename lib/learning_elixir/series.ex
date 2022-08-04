defmodule Series do
  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t(), non_neg_integer) :: non_neg_integer
  def largest_product(number_string, 0), do: 1

  def largest_product(number_string, size)
      when size * 8 > bit_size(number_string) or size < 0 do
    raise ArgumentError
  end

  def largest_product(number_string, size) do
    number_string
    |> String.graphemes()
    |> Enum.map(fn g -> String.to_integer(g) end)
    |> Enum.split(size)
    |> scan()
  end

  defp scan({chunk}) do
    Enum.product(chunk)
  end

  defp scan({first_chunk, digits}) do
    acc = initialize_accumulator(first_chunk)
    {_last_chunk, _last_prod, max_prod} = Enum.reduce(digits, acc, &step/2)
    max_prod
  end

  defp initialize_accumulator(first_chunk) do
    first_prod = Enum.product(first_chunk)
    current_prod = first_prod
    max_prod = first_prod
    {first_chunk, current_prod, max_prod}
  end

  defp step(digit, {[head | tail], last_iter_prod, max_prod}) do
    current_prod = if(head == 0, do: Enum.product(tail) * digit, else: div(last_iter_prod, head) * digit)
    max_prod = max(max_prod, current_prod)
    chunk = tail ++ [digit]
    {chunk, current_prod, max_prod}
  end

end
