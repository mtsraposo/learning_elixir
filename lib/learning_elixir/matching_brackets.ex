defmodule MatchingBrackets do
  @brackets Map.new([
    {"(", ")"},
    {"[", "]"},
    {"{", "}"}
  ])
  @opening Map.keys(@brackets)
  @closing Map.values(@brackets)

  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    str
    |> parse()
    |> Enum.reduce_while([], &match_punct/2)
    |> Enum.empty?()
  end

  defp parse(str) do
    str
    |> String.replace(~r"[^\(\)\[\]\{\}]", "")
    |> String.graphemes()
  end

  defp match_punct(bracket, []) do
    if bracket in @opening do
      {:cont, [bracket]}
    else
      {:halt, [bracket]}
    end
  end

  defp match_punct(bracket, [head | tail]) do
    cond do
      bracket in @opening -> {:cont, [bracket | [head | tail]]}
      (bracket in @closing) and (head |> matches_closing?(bracket)) -> {:cont, tail}
      true -> {:halt, [bracket | tail]}
    end
  end

  defp matches_closing?(head, bracket) do
    Map.get(@brackets, head) == bracket
  end
end
