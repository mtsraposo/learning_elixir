defmodule BoutiqueSuggestions do
  def get_combinations(tops, bottoms, options \\ []) do
    maximum_price = Keyword.get(options, :maximum_price) || 100
    for top <- tops, bottom <- bottoms,
        top[:base_color] != bottom[:base_color] and top[:price] + bottom[:price] <= maximum_price do
      {top, bottom}
    end
  end
end
