defmodule Clock do
  defstruct hour: 0, minute: 0

  @minutes_in_day 24 * 60

  defimpl String.Chars do
    def to_string(%Clock{hour: hour, minute: minute}) do
      hour = :io_lib.format("~2..*B", ["0", hour])
      minute = :io_lib.format("~2..*B", ["0", minute])
      "#{hour}:#{minute}"
    end
  end

  @doc """
  Returns a clock that can be represented as a string:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) do
    calc_minutes_from_midnight(hour, minute)
    |> to_clock()
  end

  defp calc_minutes_from_midnight(hour, minute) do
    minutes = 60 * hour + minute
    if minutes >= 0,
       do: rem(minutes, @minutes_in_day),
       else: @minutes_in_day - rem(abs(minutes), @minutes_in_day)
  end

  defp to_clock(minutes) do
    %Clock{hour: div(minutes, 60),
      minute: rem(minutes, 60)}
  end

  @doc """
  Adds two clock times:

      iex> Clock.new(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    new(hour, minute + add_minute)
  end
end
