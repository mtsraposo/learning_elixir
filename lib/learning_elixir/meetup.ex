defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
            | :thursday
            | :friday
              | :saturday
              | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @weeks %{
    first: 1,
    second: 2,
    third: 3,
    fourth: 4
  }

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: Date.t()
  def meetup(year, month, weekday, schedule) do
    get_top_of_interval_date(year, month, schedule)
    |> backtrack_to(weekday)
  end

  defp get_top_of_interval_date(year, month, :last) do
    Date.end_of_month(Date.new!(year, month, 1))
  end

  defp get_top_of_interval_date(year, month, :teenth) do
    Date.new!(year, month, 19)
  end

  defp get_top_of_interval_date(year, month, schedule) do
    Date.new!(year, month, 7 * Map.get(@weeks, schedule))
  end

  defp backtrack_to(date, weekday) do
    date
    |> Date.beginning_of_week(weekday)
  end

end
