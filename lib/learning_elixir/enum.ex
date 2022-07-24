defmodule BoutiqueInventory do
  def sort_by_price(inventory), do: Enum.sort(inventory, &(&1[:price] <= &2[:price]))

  def with_missing_price(inventory), do: Enum.filter(inventory, &(&1[:price] == nil))

  def update_names(inventory, old_word, new_word), do: inventory |> Enum.map(&(replace_names(&1, old_word, new_word)))
  defp replace_names(map, old_word, new_word), do: Map.update!(map, :name, &(String.replace(&1, old_word, new_word)))

  def increase_quantity(item, count), do: item |> Map.update!(:quantity_by_size, &(increase_by_size(&1, count)))
  defp increase_by_size(map, count), do: Enum.into(map, %{}, fn {k,v} -> {k, v + count} end)

  def total_quantity(item), do: item[:quantity_by_size] |> Enum.reduce(0, fn {k,v}, acc -> v + acc end)
end
