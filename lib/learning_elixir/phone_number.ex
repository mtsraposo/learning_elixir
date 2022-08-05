defmodule PhoneNumber do
  @numerals %{"0" => "zero", "1" => "one"}

  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """
  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    with no_separators <- remove_separators(raw),
         {:ok, only_digits} <- validate_digits(no_separators),
         graphemes <- String.graphemes(only_digits),
         {:ok, ten_digits} <- validate_length(graphemes),
         codes <- parse(ten_digits),
         {:ok, valid_codes} <- validate_codes(codes),
         number <- get_number(valid_codes) do
      {:ok, number}
    else
      {:error, e} -> {:error, e}
    end
  end

  defp remove_separators(raw) do
    String.replace(raw, ~r"[\s\-\.\+\(\)]", "")
  end

  defp validate_digits(no_separators) do
    if String.match?(no_separators, ~r".*[^\d].*") do
      {:error, "must contain digits only"}
    else
      {:ok, no_separators}
    end
  end

  defp validate_length(graphemes) do
    cond do
      length(graphemes) < 10 or length(graphemes) > 11 -> {:error, "incorrect number of digits"}
      length(graphemes) == 11 and hd(graphemes) != "1" -> {:error, "11 digits must start with 1"}
      length(graphemes) == 11 -> {:ok, Enum.drop(graphemes, 1)}
      true -> {:ok, graphemes}
    end
  end

  defp parse(ten_digits) do
    [0..2, 3..5, 6..9]
    |> Enum.map(&Enum.slice(ten_digits, &1))
  end

  defp validate_codes([area_code, exchange_code, subscriber_number] = codes) do
    cond do
      hd(area_code) in ["0", "1"] -> {:error, "area code #{error(area_code)}"}
      hd(exchange_code) in ["0", "1"] -> {:error, "exchange code #{error(exchange_code)}"}
      true -> {:ok, codes}
    end
  end

  defp error(code) do
    "cannot start with #{Map.get(@numerals, hd(code))}"
  end

  defp get_number(valid_codes) do
    valid_codes
    |> List.flatten()
    |> Enum.join()
  end
end
