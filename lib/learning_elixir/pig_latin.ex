defmodule PigLatin do
  @vowels ~w(a e i o u)

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split()
    |> Enum.map(&do_translate(String.graphemes(&1)))
    |> Enum.join(" ")
  end

  defp do_translate(["x", c | rest] = word)
       when c not in @vowels do
    word ++ ~w(a y)
  end

  defp do_translate(["y", c | rest] = word)
       when c not in @vowels do
    word ++ ~w(a y)
  end

  defp do_translate(["q", "u" | rest]) do
    rest ++ ~w(q u a y)
  end

  defp do_translate([c | rest])
       when c not in @vowels do
    do_translate(rest ++ [c])
  end

  defp do_translate(word) do
    word ++ ~w(a y)
  end

end
