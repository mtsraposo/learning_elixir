defmodule LibraryFees do
  def datetime_from_string(string), do: NaiveDateTime.from_iso8601(string) |> elem(1)

  def before_noon?(datetime), do: datetime.hour < 12

  def return_date(checkout_datetime) do
    checkout_datetime
    |> NaiveDateTime.to_date()
    |> Date.add(if(before_noon?(checkout_datetime), do: 28, else: 29))
  end

  def days_late(planned_return_date, actual_return_datetime), do: max(0, Date.diff(actual_return_datetime, planned_return_date))

  def monday?(datetime), do: datetime |> NaiveDateTime.to_date() |> Date.day_of_week() |> (&==/2).(1)

  def calculate_late_fee(checkout, return, rate) do
    actual_return_datetime = return |> datetime_from_string()
    checkout
    |> datetime_from_string()
    |> return_date()
    |> days_late(actual_return_datetime)
    |> (&*/2).(rate)
    |> (&*/2).(if(monday?(actual_return_datetime), do: 0.5, else: 1.0))
    |> Float.floor()
  end
end
