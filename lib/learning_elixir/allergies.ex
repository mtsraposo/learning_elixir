defmodule Allergies do
  @allergies %{
    0 => "eggs",
    1 => "peanuts",
    2 => "shellfish",
    3 => "strawberries",
    4 => "tomatoes",
    5 => "chocolate",
    6 => "pollen",
    7 => "cats"
  }

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) do
    Integer.to_string(rem(flags, 256), 2)
    |> String.graphemes()
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce([], &append_if_bit_is_set/2)
  end

  defp append_if_bit_is_set({"0", _index}, acc), do: acc

  defp append_if_bit_is_set({"1", index}, acc) do
    [Map.get(@allergies, index) | acc]
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item) do
    item in list(flags)
  end
end
