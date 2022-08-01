defmodule Proverb do
  @doc """
  Generate a proverb from a list of strings.
  """
  @spec recite(strings :: [String.t()]) :: String.t()
  def recite(strings) do
    Stream.resource(
      fn -> strings end,
      fn acc -> verse(acc, strings) end,
      fn _ -> IO.puts("finished parsing") end
    )
    |> Enum.join()
  end

  defp verse([first | [second | tail]], _strings) do
    {["For want of a #{first} the #{second} was lost.\n"], [second | tail]}
  end

  defp verse([_last], strings) do
    {["And all for the want of a #{hd(strings)}.\n"], []}
  end

  defp verse([], _strings) do
    {:halt, []}
  end
end
