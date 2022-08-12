defmodule Alphametics do
  @type puzzle :: binary
  @type solution :: %{required(?A..?Z) => 0..9}

  @doc """
  Takes an alphametics puzzle and returns a solution where every letter
  replaced by its number will make a valid equation. Returns `nil` when
  there is no valid solution to the given puzzle.

  ## Examples

    iex> Alphametics.solve("I + BB == ILL")
    %{?I => 1, ?B => 9, ?L => 0}

    iex> Alphametics.solve("A == B")
    nil
  """
  @spec solve(puzzle) :: solution | nil
  def solve(puzzle) do
    puzzle
    |> String.replace(~r/\s/, "")
    |> split_operands()
    |> scan()
    |> to_codepoints()
  end

  defp split_operands(puzzle) do
    [sum, result] = String.split(puzzle, "==")
    operands = String.split(sum, "+")
    {operands, result}
  end

  defp scan({operands, result}) do
    {operands, result}
    |> map_digit_ranges()
    |> calc_permutations()
    |> Enum.find_value(& calc_sum(operands, &1) == calc_sum([result], &1) && &1)
  end

  defp map_digit_ranges({operands, result}) do
    [result | operands]
    |> Enum.reduce(%{}, &scan_operand/2)
  end

  defp scan_operand(operand, digits) do
    operand
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(digits, &update_if_cannot_be_zero/2)
  end

  defp update_if_cannot_be_zero({var, index}, map) when is_map_key(map, var) do
    Map.put(map, var, if(index == 0, do: false, else: map[var]))
  end

  defp update_if_cannot_be_zero({var, index}, map) do
    Map.put(map, var, if(index == 0, do: false, else: true))
  end

  defp calc_permutations(can_be_zero?) do
    vars = Map.keys(can_be_zero?)
    calc_permutations(MapSet.new(0..9), vars, can_be_zero?)
  end

  defp calc_permutations(starting_digits, [var], _can_be_zero?) do
    Stream.map(starting_digits, & %{var => &1})
  end

  defp calc_permutations(starting_digits, [var | tail], can_be_zero?) do
    starting_digits
    |> filter_start_with_zero(var, can_be_zero?)
    |> Stream.flat_map(&prepend_to_next_permutations(&1, starting_digits, var, tail, can_be_zero?))
  end

  defp prepend_to_next_permutations(n, starting_digits, var, tail, can_be_zero?) do
    starting_digits
    |> update_starting_digits(n)
    |> calc_permutations(tail, can_be_zero?)
    |> Stream.map(&Map.put(&1, var, n))
  end

  defp filter_start_with_zero(starting_digits, var, can_be_zero?) do
    if can_be_zero?[var],
       do: starting_digits,
       else: MapSet.delete(starting_digits, 0)
  end

  defp update_starting_digits(starting_digits, n) do
    MapSet.delete(starting_digits, n)
  end

  defp calc_sum(operands, perm) do
    operands
    |> Enum.map(fn op -> String.graphemes(op) |> Enum.map(&perm[&1]) |> Integer.undigits() end)
    |> Enum.sum()
  end

  defp to_codepoints(nil), do: nil
  defp to_codepoints(solution) do
    solution
    |> Enum.map(fn {<<codepoint>>, value} -> {codepoint, value} end)
    |> Map.new()
  end
end
