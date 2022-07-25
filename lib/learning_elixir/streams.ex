defmodule LucasNumbers do
  @moduledoc """
  Lucas numbers are an infinite sequence of numbers which build progressively
  which hold a strong correlation to the golden ratio (φ or ϕ)

  E.g.: 2, 1, 3, 4, 7, 11, 18, 29, ...
  """

  def generate(count) when is_integer(count) and count >= 1 do
    Stream.unfold({2,1}, fn
      {second_to_last, last} -> {second_to_last, {last, second_to_last + last}}
    end)
    |> Stream.take(count)
    |> Enum.to_list()
  end
  def generate(_), do: raise ArgumentError, "count must be specified as an integer >= 1"
end
