defmodule VariableLengthQuantity do
  @doc """
  Encode integers into a bitstring of VLQ encoded bytes
  """
  @spec encode(integers :: [integer]) :: binary
  def encode(integers)
      when is_list(integers) do
    integers
    |> Stream.map(&encode/1)
    |> Enum.join()
  end

  def encode(integer) do
    Integer.to_string(integer, 2)
    |> String.reverse()
    |> chunk_bytes()
    |> encode_bytes()
    |> Enum.reverse()
    |> Enum.join()
  end

  defp chunk_bytes(integer) do
    integer
    |> String.graphemes()
    |> Stream.chunk_every(7)
    |> Stream.map(&Enum.join/1)
  end

  defp encode_bytes(byte_chunks) do
    byte_chunks
    |> Stream.with_index()
    |> Stream.map(&encode_chunk/1)
  end

  defp encode_chunk({chunk, index})
       when byte_size(chunk) == 7 and index > 0 do
    encode_chunk(chunk, "1")
  end

  defp encode_chunk({chunk, 0})
       when byte_size(chunk) == 7 do
    encode_chunk(chunk, "0")
  end

  defp encode_chunk({chunk, index})
       when byte_size(chunk) < 7 do
    chunk
    |> String.pad_trailing(7, "0")
    |> (& encode_chunk({&1, index})).()
  end

  defp encode_chunk(chunk, last_bit) do
    chunk
    |> String.pad_trailing(8, last_bit)
    |> String.reverse()
    |> String.to_integer(2)
    |> (& <<&1>>).()
  end

  @doc """
  Decode a bitstring of VLQ encoded bytes into a series of integers
  """
  @spec decode(bytes :: binary) :: {:ok, [integer]} | {:error, String.t()}
  def decode(bytes)
      when is_binary(bytes) do
    bytes
    |> to_bits()
    |> decode_sequence()
  end

  defp to_bits(bytes) do
    bytes
    |> String.codepoints()
    |> Enum.map(fn <<c>> -> Integer.to_string(c, 2) |> String.pad_leading(8, "0") end)
  end

  defp decode_sequence([<<"1", _rest::binary-size(7)>>]) do
    {:error, "incomplete sequence"}
  end

  defp decode_sequence(bytes) do
    {:ok, decode_bytes(bytes)}
  end

  defp decode_bytes(bytes) do
    bytes
    |> Enum.reduce([[]], &decode_segment/2)
    |> remove_last_iteration_starter()
    |> Enum.reverse()
  end

  defp decode_segment(<<"1", rest::binary-size(7)>>, [current_binary | decoded_integers]) do
    [[rest | current_binary] | decoded_integers]
  end

  defp decode_segment(<<"0", rest::binary>>, [[]]), do: [[], String.to_integer(rest, 2)]
  defp decode_segment(<<"0", rest::binary>>, [current_binary | decoded_integers]) do
    [rest | current_binary]
    |> to_integer()
    |> prepend_to_decoded(decoded_integers)
    |> prepare_for_next_iteration()
  end

  defp to_integer(b) do
    b
    |> Enum.reverse()
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp prepend_to_decoded(integer, decoded_integers) do
    [integer | decoded_integers]
  end

  defp prepare_for_next_iteration(acc) do
    [[] | acc]
  end

  defp remove_last_iteration_starter(decoded) do
    Enum.filter(decoded, &is_integer/1)
  end
end
