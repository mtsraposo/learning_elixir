defmodule PigLatin do
  @vowel_sounds MapSet.new([?a, ?e, ?i, ?o, ?u] ++ [?A, ?E, ?I, ?O, ?U])
  @y MapSet.new([?y, ?Y])

  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split()
    |> Enum.map(&do_translate(&1))
    |> Enum.join(" ")
  end

  defp do_translate(word) do
    if starts_with_vowel_sound?(word) do
      translate(word, "vowel")
    else
      translate(word, "consonant")
    end
  end

  defp starts_with_vowel_sound?(word) do
    chars = String.to_charlist(word)
    starts_with_vowel?(chars) or starts_with_pseudo_vowel?(chars)
  end

  defp starts_with_vowel?(chars), do: MapSet.member?(@vowel_sounds, hd(chars))

  defp starts_with_pseudo_vowel?(chars) do
    starts_with_xy? = hd(chars) in [?x, ?y]

    second_letter = Enum.at(chars, 1)
    second_letter_is_consonant? = not MapSet.member?(@vowel_sounds, second_letter)

    starts_with_xy? and second_letter_is_consonant?
  end

  defp translate(word, "vowel"), do: word <> "ay"

  defp translate(word, "consonant") do
    {cluster, rest} = split_cluster(word)
    rest <> cluster <> "ay"
  end

  defp split_cluster(word) do
    chars = String.to_charlist(word)

    starts_with_y? = hd(chars) in [?y, ?Y]
    cluster = if(starts_with_y?, do: "y", else: traverse(chars))
    cluster = if(ends_with_qu_sound?(chars, cluster), do: cluster <> "u", else: cluster)

    rest = String.split(word, cluster, parts: 2) |> Enum.at(1)

    {cluster, rest}
  end

  defp traverse(chars) do
    cluster = chars
              |> Enum.take_while(fn c -> not MapSet.member?(@vowel_sounds, c) and not MapSet.member?(@y, c) end)
              |> List.to_string()
  end

  defp ends_with_qu_sound?(chars, cluster) do
    ends_with_q? = String.last(cluster) == "q"

    cluster_length = String.length(cluster)
    has_qu_sound? = Enum.at(chars, cluster_length) == ?u

    ends_with_q? and has_qu_sound?
  end

end
