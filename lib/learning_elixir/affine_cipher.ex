defmodule AffineCipher do
  import Kernel, except: [to_string: 1]

  @m Enum.count(?a..?z)

  @typedoc """
  A type for the encryption key
  """
  @type key() :: %{a: integer, b: integer}

  @doc """
  Encode an encrypted message using a key
  """
  @spec encode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def encode(%{a: a, b: b}, message) do
    if Integer.gcd(a, @m) == 1,
       do: {:ok, encode(a, b, message)},
       else: {:error, "a and m must be coprime."}
  end

  defp encode(a, b, message)
       when is_binary(message) do
    message
    |> parse()
    |> Stream.map(&encode(a, b, &1))
    |> chunk()
  end

  defp parse(message) do
    message
    |> String.replace(~r"[[:punct:]\s]", "")
    |> String.downcase()
    |> String.to_charlist()
  end

  defp encode(a, b, codepoint)
       when codepoint not in ?a..?z do
    <<codepoint>>
  end

  defp encode(a, b, codepoint)
       when codepoint in ?a..?z do
    i = codepoint - ?a
    <<rem(a * i + b, @m) + ?a>>
  end

  defp chunk(encoded) do
    encoded
    |> Stream.chunk_every(5)
    |> Stream.map(&Enum.join(&1))
    |> Enum.join(" ")
  end

  @doc """
  Decode an encrypted message using a key
  """
  @spec decode(key :: key(), message :: String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def decode(%{a: a, b: b}, encrypted) do
    if Integer.gcd(a, @m) == 1,
       do: {:ok, do_decode(a, b, encrypted)},
       else: {:error, "a and m must be coprime."}
  end

  defp do_decode(a, b, encrypted)
       when is_binary(encrypted) do
    encrypted
    |> parse()
    |> Stream.map(&decode(a, b, &1))
    |> Enum.join()
  end

  defp decode(a, b, codepoint)
       when codepoint not in ?a..?z do
    <<codepoint>>
  end

  defp decode(a, b, codepoint) do
    calc_offset(a, b, codepoint)
    |> to_string()
  end

  defp calc_offset(a, b, codepoint) do
    mmi = calc_mmi(a)
    y = codepoint - ?a
    mmi * (y - b)
  end

  defp calc_mmi(a) do
    {_, mmi, _} = Integer.extended_gcd(a, @m)
    mmi
  end

  defp to_string(offset)
       when offset < 0 do
    <<@m + rem(offset, @m) + ?a>>
  end

  defp to_string(offset) do
    <<rem(offset, @m) + ?a>>
  end
end
