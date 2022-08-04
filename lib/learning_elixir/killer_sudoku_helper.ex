defmodule KillerSudokuHelper do
  @doc """
  Return the possible combinations of `size` distinct numbers from 1-9 excluding `exclude` that sum up to `sum`.
  """
  @spec combinations(cage :: %{exclude: [integer], size: integer, sum: integer}) :: [[integer]]
  def combinations(cage)
      when cage.size == 0 or cage.sum <= 0 do
    [[]]
  end

  def combinations(cage) do
    candidate_numbers(cage)
    |> Enum.map(fn n -> cage |> combinations_containing(n) end)
    |> merge()
    |> filter_matching(cage)
  end

  defp candidate_numbers(cage) do
    1..9
    |> Enum.filter(fn n -> n not in cage.exclude end)
  end

  defp combinations_containing(cage, n) do
    combinations(%{exclude: [n | cage.exclude], size: cage.size - 1, sum: cage.sum - n})
    |> Enum.map(fn comb -> [n | comb] end)
  end

  defp merge(combinations) do
    combinations
    |> Enum.reduce([], fn combs, merged -> merged ++ combs end)
  end

  defp filter_matching(combinations, cage) do
    combinations
    |> Enum.filter(fn comb -> Enum.sum(comb) == cage.sum and length(comb) == cage.size end)
    |> Enum.map(fn comb -> Enum.sort(comb) end)
    |> Enum.uniq()
  end
end
