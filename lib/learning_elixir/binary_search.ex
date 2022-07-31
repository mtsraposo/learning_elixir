defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search(numbers, key) do
    search(numbers, key, 0, tuple_size(numbers) - 1)
  end

  defp search(numbers, key, left, right)
       when left > right do
    :not_found
  end

  defp search(numbers, key, left, right) do
    midpoint = div(left + right, 2)
    midvalue = elem(numbers, midpoint)
    cond do
      key == midvalue -> {:ok, midpoint}
      key > midvalue -> search(numbers, key, midpoint + 1, right)
      key < midvalue -> search(numbers, key, left, midpoint - 1)
    end
  end

end
