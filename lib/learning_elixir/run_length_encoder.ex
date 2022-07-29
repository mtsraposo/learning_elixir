defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t()) :: String.t()
  def encode(string) do
    string
    |> String.graphemes()
    |> Enum.reduce([], &group_by_grapheme/2)
    |> Enum.reverse()
    |> Enum.reduce("", &prepend_frequency/2)
  end

  defp group_by_grapheme(char, freqs) do
    case freqs do
      [{^char, freq} | tail] -> [{char, freq + 1} | tail]
      _ -> [{char, 1} | freqs]
    end
  end

  defp prepend_frequency({char, 1}, encoded) do
    encoded <> "#{char}"
  end

  defp prepend_frequency({char, freq}, encoded) do
    encoded <> "#{freq}#{char}"
  end

  @spec decode(String.t()) :: String.t()
  def decode(string) do
    {_freq, decoded} = string
                       |> split_decoders()
                       |> Enum.reduce({1, ""}, &duplicate_graphemes/2)

    decoded
  end

  defp split_decoders(string) do
    String.split(string, ~r/[a-zA-Z\s]/, include_captures: true, trim: true)
  end

  defp duplicate_graphemes(string, {freq, decoded}) do
    if string |> represents_integer?() do
      update_next_frequency(string, decoded)
    else
      duplicate_and_reset_frequency(string, freq, decoded)
    end
  end

  defp represents_integer?(string) do
    String.match?(string, ~r/^[\d]+$/)
  end

  defp update_next_frequency(string, decoded) do
    {String.to_integer(string), decoded}
  end

  defp duplicate_and_reset_frequency(string, freq, decoded) do
    {1, decoded <> String.duplicate(string, freq)}
  end
end
