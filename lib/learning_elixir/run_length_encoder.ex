defmodule RunLengthEncoder do
  @letters_or_whitespace "a-zA-Z\s"

  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    sequences_of_equal_letters_or_whitespace = ~r"([#{@letters_or_whitespace}])\1*"
    Regex.replace(sequences_of_equal_letters_or_whitespace, string, &encode/2)
  end

  defp encode(group, char)
       when group == char do
    char
  end

  defp encode(group, char) do
    "#{String.length(group)}#{char}"
  end

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    sequences_of_digits_followed_by_letters_or_whitespace = ~r"(\d*)([#{@letters_or_whitespace}])"
    Regex.replace(sequences_of_digits_followed_by_letters_or_whitespace, string, &duplicate/3)
  end

  defp duplicate(group, freq, char) do
    freq
    |> to_integer()
    |> duplicate(char)
  end

  defp to_integer(freq) do
    freq
    |> String.replace(~r{^$}, "1")
    |> String.to_integer()
  end

  defp duplicate(freq, char) do
    String.duplicate(char, freq)
  end
end
