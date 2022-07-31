defmodule Bob do
  import Kernel, except: [match?: 2]

  @responses %{
    uppercase_question: "Calm down, I know what I'm doing!",
    any_question: "Sure.",
    silence: "Fine. Be that way!",
    uppercase_statement: "Whoa, chill out!",
    default: "Whatever."
  }

  @spec hey(String.t()) :: String.t()
  def hey(input) do
    gen_patterns()
    |> to_sentences()
    |> match(input)
  end

  defp gen_patterns() do
    uppercase_sentence = "[^[:lower:]]*[[:upper:]]+[^[:lower:]]*"
    [
      uppercase_question: ~r"^#{uppercase_sentence}\?\s*$",
      uppercase_statement: ~r"^#{uppercase_sentence}$",
      any_question: ~r"^.+\?\s*$",
      silence: ~r"^\s*$"
    ]
  end

  defp to_sentences(patterns) do
    patterns
    |> Enum.map(fn {name, regex} -> {regex, Map.get(@responses, name)} end)
  end

  defp match(regex_to_sentence, input) do
    default = Map.get(@responses, :default)
    regex_to_sentence
    |> Enum.find_value(default, &match?(&1, input))
  end

  defp match?({regex, sentence}, input) do
    if(input =~ regex, do: sentence)
  end
end
