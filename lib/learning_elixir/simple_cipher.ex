defmodule SimpleCipher do
  @doc """
  Given a `plaintext` and `key`, encode each character of the `plaintext` by
  shifting it by the corresponding letter in the alphabet shifted by the number
  of letters represented by the `key` character, repeating the `key` if it is
  shorter than the `plaintext`.

  For example, for the letter 'd', the alphabet is rotated to become:

  defghijklmnopqrstuvwxyzabc

  You would encode the `plaintext` by taking the current letter and mapping it
  to the letter in the same position in this rotated alphabet.

  abcdefghijklmnopqrstuvwxyz
  defghijklmnopqrstuvwxyzabc

  "a" becomes "d", "t" becomes "w", etc...

  Each letter in the `plaintext` will be encoded with the alphabet of the `key`
  character in the same position. If the `key` is shorter than the `plaintext`,
  repeat the `key`.

  Example:

  plaintext = "testing"
  key = "abc"

  The key should repeat to become the same length as the text, becoming
  "abcabca". If the key is longer than the text, only use as many letters of it
  as are necessary.
  """
  def encode(plaintext, key) do
    plaintext
    |> map_to_key_entries(key)
    |> Enum.map(&encode/1)
    |> List.to_string()
  end

  defp map_to_key_entries(text, key) do
    text
    |> calc_dimensions(key)
    |> format(String.downcase(key))
    |> String.to_charlist()
    |> Enum.map(&(&1 - ?a))
    |> Enum.zip(text |> to_charlist())
  end

  defp calc_dimensions(plaintext, key) do
    {len_key, len_text} = {String.length(key), String.length(plaintext)}
    {div(len_text, len_key), rem(len_text, len_key)}
  end

  defp format({0, rest}, key) do
    String.slice(key, 0..(rest-1))
  end

  defp format({n, rest}, key) do
    String.duplicate(key, n) <> format({0, rest}, key)
  end

  defp encode({key, text}) do
    ?a + rem(text + key - ?a, ?z - ?a + 1)
  end

  @doc """
  Given a `ciphertext` and `key`, decode each character of the `ciphertext` by
  finding the corresponding letter in the alphabet shifted by the number of
  letters represented by the `key` character, repeating the `key` if it is
  shorter than the `ciphertext`.

  The same rules for key length and shifted alphabets apply as in `encode/2`,
  but you will go the opposite way, so "d" becomes "a", "w" becomes "t",
  etc..., depending on how much you shift the alphabet.
  """
  def decode(ciphertext, key) do
    ciphertext
    |> map_to_key_entries(key)
    |> Enum.map(&decode/1)
    |> List.to_string()
  end

  defp decode({key, text}) do
    ?z - rem(?z - text + key, ?z - ?a + 1)
  end

  @doc """
  Generate a random key of a given length. It should contain lowercase letters only.
  """
  def generate_key(length) do
    1..length
    |> Enum.reduce("", &generate_key/2)
  end

  defp generate_key(_n, key) do
    key <> List.to_string([?a + :rand.uniform(?z-?a)])
  end
end
