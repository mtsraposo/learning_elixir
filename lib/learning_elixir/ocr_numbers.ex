defmodule OcrNumbers do
  @numbers %{
    " _ \n| |\n|_|\n   " => "0",
    "   \n  |\n  |\n   " => "1",
    " _ \n _|\n|_ \n   " => "2",
    " _ \n _|\n _|\n   " => "3",
    "   \n|_|\n  |\n   " => "4",
    " _ \n|_ \n _|\n   " => "5",
    " _ \n|_ \n|_|\n   " => "6",
    " _ \n  |\n  |\n   " => "7",
    " _ \n|_|\n|_|\n   " => "8",
    " _ \n|_|\n _|\n   " => "9"
  }

  @doc """
  Given a 3 x 4 grid of pipes, underscores, and spaces, determine which number is represented, or
  whether it is garbled.
  """
  @spec convert([String.t()]) :: {:ok, String.t()} | {:error, String.t()}
  def convert(input) do
    with {:ok, input} <- check_size(input),
         result <- convert_text(input) do
      {:ok, result}
    else
      {:error, message} -> {:error, message}
    end
  end

  defp check_size(input) do
    with {:ok, input} <- check_line_count(input),
         {:ok, input} <- check_column_count(input) do
      {:ok, input}
    else
      {:error, message} -> {:error, message}
    end
  end

  defp check_line_count(input) do
    if rem(length(input), 4) == 0,
       do: {:ok, input},
       else: {:error, "invalid line count"}
  end

  defp check_column_count(input) do
    if Enum.any?(input, & rem(String.length(&1), 3) != 0),
       do: {:error, "invalid column count"},
       else: {:ok, input}
  end

  defp convert_text(input) do
    input
    |> Enum.chunk_every(4)
    |> Enum.map(&convert_line/1)
    |> Enum.join(",")
  end

  defp convert_line(line) do
    line
    |> split_digits()
    |> convert_digits()
    |> Enum.join()
  end

  defp split_digits(line) do
    line
    |> Stream.map(&chunk_by_column/1)
    |> Stream.zip_with(&(&1))
    |> Stream.map(&Enum.join(&1, "\n"))
  end

  defp chunk_by_column(row) do
    row
    |> String.graphemes()
    |> Stream.chunk_every(3)
    |> Stream.map(&Enum.join/1)
  end

  defp convert_digits(digits) do
    digits
    |> Stream.map(& @numbers[&1] || "?")
  end

end
