defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t()}
  def generate(_coins, 0), do: {:ok, []}

  def generate(coins, target) do
    1..target
    |> Enum.reduce(%{}, &gen_change_up_to_target(coins, &1, &2))
    |> get_coins(List.last(coins), target)
  end

  defp gen_change_up_to_target(coins, target, matrix) do
    initial_row_state = {_initial_row_coin, _initial_row_count} = {nil, 0}
    coins
    |> Enum.reduce({%{}, initial_row_state}, &gen_change_up_to_coin(&1, target, matrix, &2))
    |> update_row(target, matrix)
  end

  defp gen_change_up_to_coin(coin, target, matrix, {row, {row_coin, row_count}}) do
    can_change?(coin, target, matrix, row_coin, row_count)
    |> update_cell(row, coin)
  end

  defp can_change?(coin, target, matrix, row_coin, row_count) do
    cond do
      target == coin -> {coin, 1}
      can_complement?(coin, target, matrix) -> minimize_coins(coin, target, matrix, row_coin, row_count)
      true -> {row_coin, row_count}
    end
  end

  defp can_complement?(coin, target, matrix) do
    if matrix[target - coin],
       do: can_change?(coin, target - coin, matrix),
       else: false
  end

  defp can_change?(coin, target, matrix) do
    {coin_or_nil, _count} = matrix[target][coin]
    coin_or_nil
  end

  defp minimize_coins(coin, target, matrix, row_coin, row_count) do
    {_prev_coin, prev_count} = matrix[target - coin][coin]
    if prev_count < row_count or row_count == 0,
       do: {coin, prev_count + 1},
       else: {row_coin, row_count}
  end

  defp update_cell({_row_coin, _row_count} = row_state, row, coin) do
    {Map.put(row, coin, row_state), row_state}
  end

  defp update_row({row, _last_coin}, target, matrix) do
    Map.put(matrix, target, row)
  end

  defp get_coins(matrix, last_coin, target) do
    if can_change?(last_coin, target, matrix),
       do: {:ok, build_change_set(last_coin, target, matrix) |> Enum.sort()},
       else: {:error, "cannot change"}
  end

  defp build_change_set(_last_coin, 0, _matrix), do: []

  defp build_change_set(last_coin, target, matrix) do
    {coin, _count} = matrix[target][last_coin]
    [coin | build_change_set(last_coin, target - coin, matrix)]
  end
end
