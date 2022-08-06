defmodule FoodChain do
  @animals %{1 => "fly", 2 => "spider", 3 => "bird", 4 => "cat",
    5 => "dog", 6 => "goat",   7 => "cow",  8 => "horse"}

  @second_verses %{
    2 => "It wriggled and jiggled and tickled inside her.",
    3 => "How absurd to swallow a bird!",
    4 => "Imagine that, to swallow a cat!",
    5 => "What a hog, to swallow a dog!",
    6 => "Just opened her throat and swallowed a goat!",
    7 => "I don't know how she swallowed a cow!"
  }

  @chorus_verse_appendix "that wriggled and jiggled and tickled inside her"

  @doc """
  Generate consecutive verses of the song 'I Know an Old Lady Who Swallowed a Fly'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    start..stop
    |> Enum.map(&paragraph/1)
    |> Enum.join("\n")
  end

  defp paragraph(p) do
    1..verses_in_paragraph(p)
    |> Enum.map(&verse(&1, p))
  end

  defp verses_in_paragraph(p) do
    if p > 1 and p < 8,
       do: p + 2,
       else: 2
  end

  defp verse(1, p) do
    "I know an old lady who swallowed a #{Map.get(@animals, p)}.\n"
  end

  defp verse(2, p) when p in [1,8], do: last_verse(p)
  defp verse(2, p), do: "#{Map.get(@second_verses, p)}\n"

  defp verse(v, p) when v > 2 and v < p + 2, do: chorus_verse(v, p)

  defp verse(v, p) when v == p + 2, do: last_verse(p)

  defp chorus_verse(v, p) do
    "She swallowed the #{animal(v, p)} to catch the #{other_animal(v, p)}.\n"
  end

  defp animal(v, p), do: Map.get(@animals, p - v + 3)

  defp other_animal(v, p) when v == p, do: "#{animal(v + 1, p)} #{@chorus_verse_appendix}"
  defp other_animal(v, p), do: animal(v + 1, p)

  defp last_verse(8), do: "She's dead, of course!\n"
  defp last_verse(_p), do: "I don't know why she swallowed the fly. Perhaps she'll die.\n"

end
