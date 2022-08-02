defmodule TwelveDays do
  @gifts ["a Partridge in a Pear Tree", "two Turtle Doves", "three French Hens",
    "four Calling Birds", "five Gold Rings", "six Geese-a-Laying",
    "seven Swans-a-Swimming", "eight Maids-a-Milking", "nine Ladies Dancing",
    "ten Lords-a-Leaping", "eleven Pipers Piping", "twelve Drummers Drumming"]

  @ordinals %{
    1 => "first", 2 => "second", 3 => "third", 4 => "fourth", 5 => "fifth",
    6 => "sixth", 7 => "seventh", 8 => "eighth", 9 => "ninth", 10 => "tenth",
    11 => "eleventh", 12 => "twelfth"
  }

  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(1) do
    "#{predicate(1)}: #{hd(@gifts)}."
  end

  def verse(number) do
    "#{predicate(number)}: #{object(number)}."
  end

  defp predicate(number) do
    "On the #{ordinal(number)} day of Christmas my true love gave to me"
  end

  defp object(number) do
    [head | tail] = Enum.take(@gifts, number)

    ["and #{head}" | tail]
    |> Enum.reverse()
    |> Enum.join(", ")
  end

  defp ordinal(number) do
    Map.get(@ordinals, number)
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    starting_verse..ending_verse
    |> Enum.reduce("", fn n, song -> "#{song}#{verse(n)}\n" end)
    |> String.trim()
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing() :: String.t()
  def sing do
    verses(1, 12)
  end
end
