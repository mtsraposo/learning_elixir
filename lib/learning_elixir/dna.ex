defmodule DNA do
  @char_to_code %{
    ?\s => 0b0000,
    ?A => 0b0001,
    ?C => 0b0010,
    ?G => 0b0100,
    ?T => 0b1000
  }

  def encode_nucleotide(code_point) do
    Map.get(@char_to_code, code_point)
  end

  def decode_nucleotide(encoded_code) do
    @char_to_code
    |> Map.filter(fn {_key, val} -> val == encoded_code end)
    |> Map.keys()
    |> Enum.at(0)
  end

  def encode(dna), do: encode(dna, <<>>)
  defp encode([], encoded), do: encoded
  defp encode([head | tail], encoded), do: encode(tail, <<encoded::bitstring, encode_nucleotide(head)::4>>)

  def decode(dna), do: decode(dna, '')
  defp decode(<<>>, decoded), do: decoded |> Enum.reverse()
  defp decode(<<code_point::4, rest::bitstring>>, decoded), do: decode(rest, [decode_nucleotide(code_point) | decoded])
end