defmodule LucasNumbers do
  @moduledoc """
  Lucas numbers are an infinite sequence of numbers which build progressively
  which hold a strong correlation to the golden ratio (φ or ϕ)

  E.g.: 2, 1, 3, 4, 7, 11, 18, 29, ...
  """
  def generate(wrong_arg) when not(is_integer(wrong_arg)) or wrong_arg < 1, do: raise ArgumentError, "count must be specified as an integer >= 1"
  def generate(1), do: [2]
  def generate(2), do: [2, 1]
  def generate(count) do
    stop = count + 1
    Stream.unfold([2 | generate(2)], fn
      [^stop, _, _] -> nil
      [index, second_to_last, last] -> {[index, second_to_last, last], [index + 1, last, second_to_last + last]}
    end)
    |> Stream.drop(1)
    |> Stream.map(fn [_, _, n] -> n end)
    |> (&(Stream.concat(generate(2), &1))).()
    |> Enum.to_list()
  end
end
