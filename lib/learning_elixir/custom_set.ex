defmodule CustomSet do
  defstruct map: %{}

  @opaque t :: %__MODULE__{map: map}

  @spec new(Enum.t()) :: t
  def new(enumerable) do
    enumerable
    |> Enum.reduce(%{}, fn e, set -> Map.put(set, e, 0) end)
    |> (& %CustomSet{map: &1}).()
  end

  @spec empty?(t) :: boolean
  def empty?(custom_set) do
    map_size(custom_set.map) == 0
  end

  @spec contains?(t, any) :: boolean
  def contains?(custom_set, element) do
    Map.get(custom_set.map, element) != nil
  end

  @spec subset?(t, t) :: boolean
  def subset?(custom_set_1, custom_set_2) do
    custom_set_1.map
    |> Enum.reduce_while(true, fn {k1, 0}, result -> if contains?(custom_set_2, k1),
                                                        do: {:cont, true},
                                                        else: {:halt, false} end)
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2) do
    custom_set_1.map
    |> Enum.reduce_while(true, fn {k1, 0}, result -> unless contains?(custom_set_2, k1),
                                                            do: {:cont, true},
                                                            else: {:halt, false} end)
  end

  @spec equal?(t, t) :: boolean
  def equal?(custom_set_1, custom_set_2) do
    (map_size(custom_set_1.map) == map_size(custom_set_2.map))
    |> Kernel.and(custom_set_1 |> subset?(custom_set_2))
  end

  @spec add(t, any) :: t
  def add(custom_set, element) do
    %CustomSet{map: Map.put(custom_set.map, element, 0)}
  end

  @spec intersection(t, t) :: t
  def intersection(custom_set_1, custom_set_2) do
    custom_set_1.map
    |> Enum.reduce(new([]), fn {k1, 0}, result -> if contains?(custom_set_2, k1),
                                                     do: add(result, k1),
                                                     else: result end)
  end

  @spec difference(t, t) :: t
  def difference(custom_set_1, custom_set_2) do
    custom_set_1.map
    |> Enum.reduce(new([]), fn {k1, 0}, result -> unless contains?(custom_set_2, k1),
                                                         do: add(result, k1),
                                                         else: result end)
  end

  @spec union(t, t) :: t
  def union(custom_set_1, custom_set_2) do
    [custom_set_1, custom_set_2]
    |> Enum.reduce(new([]), fn set, result -> Enum.reduce(set.map, result, fn {k, 0}, r -> add(r, k) end) end)
  end
end
