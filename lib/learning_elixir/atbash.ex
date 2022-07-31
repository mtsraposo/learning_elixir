defmodule Atbash do
  @encode Map.new(Enum.zip(?a..?z, ?z..?a))
  @decode Map.new(Enum.zip(?z..?a, ?a..?z))

  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext
    |> preprocess()
    |> transform(@encode)
    |> group()
  end

  defp group(encoded) do
    encoded
    |> Stream.chunk_every(5)
    |> Stream.map(&List.to_string/1)
    |> Enum.join(" ")
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    cipher
    |> preprocess()
    |> transform(@decode)
    |> Enum.map_join(&<<&1>>)
  end

  defp preprocess(text) do
    text
    |> String.replace(~r/[[:punct:]\s]/, "")
    |> String.downcase()
    |> String.to_charlist()
  end

  defp transform(charlist, map) do
    charlist
    |> Stream.map(fn c -> Map.get(map, c) || c end)
  end

end
