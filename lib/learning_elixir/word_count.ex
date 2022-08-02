defmodule WordCount do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.downcase()
    |> parse_apostrophes()
    |> split_words()
    |> Enum.frequencies()
  end

  defp parse_apostrophes(sentence) do
    gen_expressions()
    |> Enum.reduce(sentence, fn regex, str -> String.replace(str, regex, "") end)
  end

  defp gen_expressions() do
    at_beginning_of_word = ~r/^(\')/u
    at_end_of_word = ~r/(\')$/u
    preceded_by_non_alphanumeric_character = ~r/(?<=[^[:alpha:]])(\')/u
    followed_by_non_alphanumeric_character = ~r/(\')(?=[^[:alpha:]])/u

    [at_beginning_of_word, at_end_of_word,
      preceded_by_non_alphanumeric_character, followed_by_non_alphanumeric_character]
  end

  defp split_words(sentence) do
    except_apostrophes_dashes_or_alphanumeric = ~r/[^\'\-[:alnum:]]+?/u
    String.split(sentence, except_apostrophes_dashes_or_alphanumeric, trim: true)
  end
end
