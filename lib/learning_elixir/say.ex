defmodule Say do
  @scale_words %{
    0 => "",
    1 => "thousand",
    2 => "million",
    3 => "billion"
  }

  @numerals %{
    0 => "zero",
    1 => "one", 2 => "two", 3 => "three", 4 => "four", 5 => "five",
    6 => "six", 7 => "seven", 8 => "eight", 9 => "nine", 10 => "ten",
    11 => "eleven", 12 => "twelve", 13 => "thirteen", 15 => "fifteen",
    20 => "twenty", 30 => "thirty", 40=> "forty", 50 => "fifty", 80 => "eighty"
  }

  @doc """
  Translate a positive integer into English.
  """
  @spec in_english(integer) :: {atom, String.t()}
  def in_english(number)
      when number < 0 or number > 999_999_999_999 do
    {:error, "number is out of range"}
  end

  def in_english(number) do
    {:ok, translate(number)}
  end

  defp translate(number)
       when number <= 12 do
    Map.get(@numerals, number)
  end

  defp translate(number)
       when number in 13..19 do
    Map.get(@numerals, number) || "#{translate(number - 10)}teen"
  end

  defp translate(number)
       when number in 20..99 and rem(number, 10) == 0 do
    Map.get(@numerals, number) || "#{translate(div(number, 10))}ty"
  end

  defp translate(number)
       when number in 20..99 and rem(number, 10) != 0 do
    [tens, units] = Integer.digits(number)
    "#{translate(tens * 10)}-#{translate(units)}"
  end

  defp translate(number)
       when number >= 100 do
    number
    |> append_scale()
    |> translate_by_scale()
  end

  defp append_scale(number) do
    number
    |> Integer.digits()
    |> Enum.reverse()
    |> Stream.chunk_every(3)
    |> Stream.with_index()
    |> Stream.map(fn {chunk, scale} -> {Enum.reverse(chunk), Map.get(@scale_words, scale)} end)
    |> Enum.reverse()
  end

  defp translate_by_scale(scaled) do
    scaled
    |> Enum.reduce("", &translate_scale/2)
    |> String.trim()
  end

  defp translate_scale({[0,0,0], _scale}, str), do: str

  defp translate_scale({chunk, scale}, str) do
    "#{str} #{translate_chunk(chunk)} #{scale}"
  end

  defp translate_chunk([0, tens, units]) do
    translate_chunk([tens, units])
  end

  defp translate_chunk([hundreds, 0, 0]) do
    "#{translate(hundreds)} hundred"
  end

  defp translate_chunk([hundreds, tens, units]) do
    "#{translate(hundreds)} hundred #{translate_chunk([tens, units])}"
  end

  defp translate_chunk([0, units]) do
    translate_chunk([units])
  end

  defp translate_chunk([tens, units]) do
    translate(tens * 10 + units)
  end

  defp translate_chunk([units]) do
    translate(units)
  end

end
