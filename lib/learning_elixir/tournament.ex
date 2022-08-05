defmodule Tournament do
  @stats %{mp: 0, w: 0, d: 0, l: 0, p: 0}
  @points %{l: 0, d: 1, w: 3}

  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> Enum.reduce(%{}, &accumulate/2)
    |> Enum.sort(&by_points_or_name/2)
    |> to_table()
  end

  defp accumulate(match, acc) do
    if Regex.match?(~r"^[\w\s]+?;[\w\s]+?;(?:win|loss|draw)$", match),
       do: String.split(match, ";") |> do_accumulate(acc),
       else: acc
  end

  defp do_accumulate([team1, team2, outcome], acc) do
    acc
    |> increment_matches_played(team1, team2)
    |> increment_outcomes(team1, team2, outcome)
    |> increment_points(team1, team2, outcome)
  end

  defp increment_matches_played(acc, team1, team2) do
    acc
    |> Map.update(team1, %{@stats | mp: 1}, &increment_matches_played/1)
    |> Map.update(team2, %{@stats | mp: 1}, &increment_matches_played/1)
  end

  defp increment_matches_played(stats) do
    Map.update!(stats, :mp, &(&1 + 1))
  end

  defp increment_outcomes(acc, team1, team2, outcome) do
    [outcome1, outcome2] = assign_outcomes(outcome)
    acc
    |> Map.update!(team1, &increment_outcomes(&1, outcome1))
    |> Map.update!(team2, &increment_outcomes(&1, outcome2))
  end

  defp increment_outcomes(stats, outcome) do
    Map.update!(stats, outcome, &(&1 + 1))
  end

  defp assign_outcomes("win"), do: [:w, :l]
  defp assign_outcomes("loss"), do: [:l, :w]
  defp assign_outcomes("draw"), do: [:d, :d]

  defp increment_points(acc, team1, team2, outcome) do
    [outcome1, outcome2] = assign_outcomes(outcome)
    acc
    |> Map.update!(team1, &increment_points(&1, outcome1))
    |> Map.update!(team2, &increment_points(&1, outcome2))
  end

  defp increment_points(stats, outcome) do
    Map.update!(stats, :p, &(&1 + Map.get(@points, outcome)))
  end

  defp by_points_or_name({team1, stats1}, {team2, stats2}) do
    if stats1.p == stats2.p,
       do: team1 < team2,
       else: stats1.p > stats2.p
  end

  defp to_table(tournament) do
    tournament
    |> Enum.map(&format/1)
    |> prepend_header()
    |> Enum.join("\n")
  end

  defp format({team, stats}) do
    "#{String.pad_trailing(team, 31)}|#{stats |> to_cols()}"
  end

  defp to_cols(stats) do
    [:mp, :w, :d, :l, :p]
    |> Enum.map(&String.pad_leading(stats |> Map.get(&1) |> Integer.to_string(), 3))
    |> Enum.join(" |")
  end

  defp prepend_header(rows) do
    ["Team                           | MP |  W |  D |  L |  P" | rows]
  end
end
