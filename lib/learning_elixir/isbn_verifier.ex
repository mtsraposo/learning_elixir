defmodule IsbnVerifier do
  @doc """
    Checks if a string is a valid ISBN-10 identifier

    ## Examples

      iex> IsbnVerifier.isbn?("3-598-21507-X")
      true

      iex> IsbnVerifier.isbn?("3-598-2K507-0")
      false

  """
  @spec isbn?(String.t()) :: boolean
  def isbn?(isbn) do
    with isbn <- remove_dashes(isbn),
         true <- has_valid_format?(isbn) do
      check_sum(isbn)
    end
  end

  defp remove_dashes(isbn) do
    String.replace(isbn, "-", "")
  end

  defp has_valid_format?(isbn) do
    isbn =~ ~r"^[0-9]{9}[0-9X]{1}$"
  end

  defp check_sum(isbn) do
    isbn
    |> enumerate_integers()
    |> sum_product()
    |> check_modulo()
  end

  defp enumerate_integers(isbn) do
    isbn
    |> String.graphemes()
    |> Enum.map(&to_integer/1)
    |> Enum.reverse()
    |> Enum.with_index()
  end

  defp to_integer("X"), do: 10
  defp to_integer(n), do: String.to_integer(n)

  defp sum_product(enum) do
    Enum.reduce(enum, 0, fn {n, i}, acc -> acc + n * (i + 1) end)
  end

  defp check_modulo(sum) do
    rem(sum, 11) == 0
  end

end
