defmodule WineCellar do
  def filter_if_keyword(opts, fun, keyword) do
    &(if Keyword.has_key?(opts, keyword) do
        apply(__MODULE__, fun, [&1, Keyword.get(opts, keyword)])
      else
        &1
      end)
  end

  def filter(cellar, color, opts \\ []) do
    Keyword.get_values(cellar, color)
    |> filter_if_keyword(opts, :filter_by_year, :year).()
    |> filter_if_keyword(opts, :filter_by_country, :country).()
  end

  # The functions below do not need to be modified.

  def filter_by_year(wines, year)
  def filter_by_year([], _year), do: []

  def filter_by_year([{_, year, _} = wine | tail], year) do
    [wine | filter_by_year(tail, year)]
  end

  def filter_by_year([{_, _, _} | tail], year) do
    filter_by_year(tail, year)
  end

  def filter_by_country(wines, country)
  def filter_by_country([], _country), do: []

  def filter_by_country([{_, _, country} = wine | tail], country) do
    [wine | filter_by_country(tail, country)]
  end

  def filter_by_country([{_, _, _} | tail], country) do
    filter_by_country(tail, country)
  end
end
