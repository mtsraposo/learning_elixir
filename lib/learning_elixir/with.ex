defmodule NewPassport do
  def get_new_passport(now, birthday, form) do
    with {:ok, timestamp} <- enter_building(now),
         {:ok, manual} <- find_counter_information(now),
         counter <- manual.(birthday),
         {:ok, checksum} <- stamp_form(timestamp, counter, form),
         passport_number <- get_new_passport_number(timestamp, counter, checksum) do
      {:ok, passport_number}
    else
      {:error, message} -> {:error, message}
      {:coffee_break, instructions} -> {:retry, NaiveDateTime.add(now, 15 * 60, :second)}
      err -> err
    end
  end

  # The dependency functions were already declared in the exercise, so I'll omit them here
end