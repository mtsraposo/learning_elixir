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
    |> Enum.flat_map(&parse/1)
    |> distribute_to(workers)
  end

  defp distribute_to(graphemes, workers)
       when length(graphemes) == 0 do
    []
  end

  defp distribute_to(graphemes, workers) do
    {chunk_size, rest} = {ceil(length(graphemes) / workers), rem(length(graphemes), workers)}
    Enum.chunk_every(graphemes, chunk_size)
    |> (& if rest == 0, do: &1, else: split_first_chunk(&1)).()
  end

  defp split_first_chunk([head | tail]) do
    {head, split} = Enum.split(head, div(length(head),2))
    [head | [split | tail]]
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
