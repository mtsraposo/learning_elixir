defmodule Yacht do
  import Kernel, except: [match?: 2]

  @type category ::
          :ones
          | :twos
          | :threes
            | :fours
            | :fives
              | :sixes
              | :full_house
                | :four_of_a_kind
                | :little_straight
                  | :big_straight
                  | :choice
                    | :yacht

  @two_small_three_big ~S"^(\d)\1(?!\1)(\d)\2\2$"
  @three_small_two_big ~S"^(\d)\3\3(?!\3)(\d)\4$"

  @yacht ~S"^(\d)\1{4}$"
  @one_small_four_big ~S"^(\d)\2{3}(?!\2)$"
  @four_small_one_big ~S"^(\d)(?!\3)(\d){4}$"

  @patterns %{
    ones: "1", twos: "2", threes: "3", fours: "4", fives: "5", sixes: "6",
    full_house: "#{@two_small_three_big}|#{@three_small_two_big}",
    four_of_a_kind: "#{@yacht}|#{@one_small_four_big}|#{@four_small_one_big}",
    little_straight: "^12345$",
    big_straight: "^23456$",
    choice: ~S"^\d{5}$",
    yacht: @yacht
  }

  @fixed_scores %{
    little_straight: 30,
    big_straight: 30,
    yacht: 50
  }

  @variable_scores %{
    ones: {:sum_repeated_digit, 1}, twos: {:sum_repeated_digit, 2},
    threes: {:sum_repeated_digit, 3}, fours: {:sum_repeated_digit, 4},
    fives: {:sum_repeated_digit, 5}, sixes: {:sum_repeated_digit, 6},
    full_house: :sum,
    four_of_a_kind: {:sum_digit_with_frequency, 4},
    choice: :sum
  }

  @doc """
  Calculate the score of 5 dice using the given category's scoring method.
  """
  @spec score(category :: category(), dice :: [integer]) :: integer
  def score(category, dice) do
    if dice |> match?(category),
       do: get_score_function(category) |> calc_score(dice),
       else: 0
  end

  defp match?(dice, category) do
    dice
    |> Enum.sort()
    |> Enum.join()
    |> String.match?(Map.get(@patterns, category) |> Regex.compile!())
  end

  defp get_score_function(category) do
    if is_map_key(@fixed_scores, category),
       do: Map.get(@fixed_scores, category),
       else: Map.get(@variable_scores, category)
  end

  defp calc_score(score, _) when is_number(score), do: score
  defp calc_score(:sum, dice), do: Enum.sum(dice)

  defp calc_score({:sum_repeated_digit, digit}, dice) do
    dice
    |> Enum.reduce(0, fn d, sum -> if(d == digit, do: sum + d, else: sum) end)
  end

  defp calc_score({:sum_digit_with_frequency, freq}, dice) do
    dice
    |> Enum.frequencies()
    |> Enum.find_value(fn {digit, f} -> f >= freq && digit end)
    |> Kernel.*(freq)
  end

end
