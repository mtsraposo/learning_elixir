defmodule StateOfTicTacToe do
  @doc """
  Determine the state a game of tic-tac-toe where X starts.
  This solution focuses more on readability than performance, as the board is very small. It would be possible to do the same
  by visiting each cell only once, but the code would be much more complicated to understand.
  """
  @spec game_state(board :: String.t()) :: {:ok, :win | :ongoing | :draw} | {:error, String.t()}
  def game_state(board) do
    with {:ok, plays} <- check_turn_order(board),
         {:ok, complete_sequences} <- check_complete_sequences(board),
         false <- win?(complete_sequences),
         false <- draw?(board, plays) do
      {:ok, :ongoing}
    else
      {:ok, state} -> {:ok, state}
      {:error, message} -> {:error, message}
    end
  end

  defp check_turn_order(board) do
    o_plays = count_plays(board, ?O)
    x_plays = count_plays(board, ?X)
    cond do
      o_plays > x_plays -> {:error, "Wrong turn order: O started"}
      o_plays < x_plays - 1 -> {:error, "Wrong turn order: X went twice"}
      o_plays <= x_plays -> {:ok, o_plays + x_plays}
    end
  end

  defp count_plays(<<player, board::binary>>, player), do: 1 + count_plays(board, player)
  defp count_plays(<<_, board::binary>>, player), do: count_plays(board, player)
  defp count_plays("", _player), do: 0

  defp check_complete_sequences(board) do
    [row, col, diag] = count_complete_sequences(board)
    if row <= 1 and col <= 1,
       do: {:ok, Enum.any?([row, col, diag], & &1 > 0) && 1 || 0},
       else: {:error, "Impossible board: game should have ended after the game was won"}
  end

  defp count_complete_sequences(board)
       when is_binary(board) do
    board
    |> String.split("\n", trim: true)
    |> Stream.map(&String.graphemes/1)
    |> (& [row_seqs(&1), col_seqs(&1), diag_seqs(&1)]).()
  end

  defp count_seqs(list) do
    list
    |> Enum.count(& Enum.uniq(&1) in [["X"], ["O"]])
  end

  defp row_seqs(board) do
    count_seqs(board)
  end

  defp col_seqs(board) do
    board
    |> transpose()
    |> count_seqs()
  end

  defp transpose(board) do
    board
    |> Enum.zip_with(&(&1))
  end

  defp diag_seqs(board) do
    board
    |> prepend_index()
    |> Enum.map(fn {index, row} -> {index, prepend_index(row) |> Map.new()} end)
    |> Map.new()
    |> get_diags()
    |> count_seqs()
  end

  defp prepend_index(list) do
    list
    |> Enum.with_index(fn elem, index -> {index, elem} end)
  end

  defp get_diags(board) do
    size = length(Map.keys(board))
    [
      0..(size - 1) |> Enum.map(&board[&1][&1]),
      0..(size - 1) |> Enum.map(&board[&1][(size - 1) - &1])
    ]
  end

  defp win?(complete_sequences) do
    if complete_sequences == 1,
       do: {:ok, :win},
       else: false
  end

  defp draw?(board, plays) do
    if plays == length(String.split(board, "\n", trim: true)) ** 2,
       do: {:ok, :draw},
       else: false
  end

end
