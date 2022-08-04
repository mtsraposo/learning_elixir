defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> chunk_tasks(workers)
    |> Task.async_stream(&Enum.frequencies/1)
    |> Enum.reduce(%{}, &sum_task_results/2)
  end

  defp chunk_tasks(texts, workers) do
    texts
    |> Enum.flat_map(fn text -> parse(text) |> Enum.chunk_every(workers) end)
  end

  defp parse(text) do
    text
    |> String.downcase()
    |> String.replace(~r/[^[:alpha:]]/u, "")
    |> String.graphemes()
  end

  defp sum_task_results({:ok, task_result}, result) do
    task_result
    |> Map.merge(result, fn _k, v1, v2 -> v1 + v2 end)
  end
end
