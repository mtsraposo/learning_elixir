defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: {:ok, non_neg_integer} | {:error, String.t()}
  def hamming_distance(strand1, strand2) do
    if valid_strands?(strand1, strand2) do
      {:ok, do_hamming_distance(strand1, strand2)}
    else
      {:error, "strands must be of equal length"}
    end
  end

  def do_hamming_distance(strand1, strand2) do
    Enum.zip(strand1, strand2)
    |> Enum.reduce(0, fn {x,y}, acc -> if(x != y, do: acc + 1, else: acc) end)
  end

  defp valid_strands?(strand1, strand2) do
    Enum.count(strand1) == Enum.count(strand2)
  end
end
