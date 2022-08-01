defmodule House do
  @verbs ["lay in", "ate", "killed", "worried", "tossed", "milked", "kissed", "married", "woke", "kept", "belonged to"]

  @objects ["house that Jack built.", "malt", "rat", "cat", "dog",
    "cow with the crumpled horn", "maiden all forlorn",
    "man all tattered and torn", "priest all shaven and shorn",
    "rooster that crowed in the morn", "farmer sowing his corn",
    "horse and the hound and the horn"]

  @doc """
  Return verses of the nursery rhyme 'This is the House that Jack Built'.
  """
  @spec recite(start :: integer, stop :: integer) :: String.t()
  def recite(start, stop) do
    for n <- start..stop, into: "" do
      verse(n) <> "\n"
    end
  end

  defp verse(number) do
    number
    |> gen_phrase_components()
    |> Enum.zip_reduce("", &append_phrase/2)
  end

  defp gen_phrase_components(number) do
    [gen_pronouns(number), gen_verbs(number), gen_objects(number)]
  end

  defp gen_pronouns(number) do
    ["This" | List.duplicate(" that", number - 1)]
  end

  defp gen_verbs(number) do
    ["is" | (Enum.take(@verbs, number - 1) |> Enum.reverse())]
  end

  defp gen_objects(number) do
    Enum.take(@objects, number) |> Enum.reverse()
  end

  defp append_phrase([pronoun, verb, object], acc) do
    acc <> "#{pronoun} #{verb} the #{object}"
  end
end
