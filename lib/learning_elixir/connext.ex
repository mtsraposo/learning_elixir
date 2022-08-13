defmodule Connect do
  @directions %{
    north: {-1, 0},
    northeast: {-1, 1},
    east: {0, 1},
    southeast: {1, 1},
    south: {1, 0},
    southwest: {1, -1},
    west: {0, -1},
    northwest: {-1, -1}
  }

  @transposed_directions %{
    north: :west,
    northeast: :southwest,
    east: :south,
    south: :east,
    southwest: :northeast,
    west: :north
  }

  @stones ["X", "O"]


  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """
  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for([stone]), do: name_winner(stone)

  def result_for(board) do
    board
    |> Enum.with_index()
    |> Enum.reduce({%{}, %{}}, &connect/2)
    |> find_winner()
  end

  defp connect({row, row_index}, {board, links}) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce({board, links}, &visit_cell(&1, &2, row_index))
  end

  defp visit_cell({cell, col_index}, {board, links}, row_index) do
    {update_board({cell, col_index}, board, row_index),
      update_links({cell, col_index}, {board, links}, row_index)}
  end

  defp update_board({cell, col_index}, board, row_index) do
    Map.update(board, row_index, %{0 => cell}, &Map.put(&1, col_index, cell))
  end

  defp update_links({cell, col_index}, {board, links}, row_index) do
    get_neighbors(board, row_index, col_index)
    |> Enum.reduce(links, &link_identical(&1, {cell, row_index, col_index}, &2))
  end

  defp get_neighbors(_board, 0, 0), do: []

  defp get_neighbors(board, row_index, 0) do
    get_previous_row_neighbors(board, row_index, 0)
  end

  defp get_neighbors(board, row_index, col_index) do
    [
      get_cell_info(board, row_index, col_index - 1)
      | get_previous_row_neighbors(board, row_index, col_index)
    ]
  end

  defp get_previous_row_neighbors(board, row_index, col_index) do
    [
      get_cell_info(board, row_index - 1, col_index),
      get_cell_info(board, row_index - 1, col_index + 1)
    ]
  end

  defp get_cell_info(board, row_index, col_index), do: {board[row_index][col_index], row_index, col_index}

  defp link_identical(neighbor, cell, links) do
    if identical_stones?(neighbor, cell),
       do: link(neighbor, cell, links)
           |> (& link(cell, neighbor, &1)).(),
       else: links
  end

  defp identical_stones?({neighbor, _, _}, {cell, _, _}) do
    neighbor == cell and cell in @stones
  end

  defp link(from, to, links) do
    update_with_direction(from, links, get_direction(from, to))
  end

  defp update_with_direction({stone, from_row, from_col}, links, direction) do
    Map.update(links, stone, %{from_row => %{from_col => [direction]}},
      &update_with_direction({from_row, from_col}, &1, direction))
  end

  defp update_with_direction({from_row, from_col}, stone_links, direction) do
    Map.update(stone_links, from_row, %{from_col => [direction]}, &update_with_direction(&1, from_col, direction))
  end

  defp update_with_direction(col_directions, from_col, direction) do
    Map.update(col_directions, from_col, [direction], & [direction | &1])
  end

  defp get_direction({_, from_row, from_col}, {_, to_row, to_col}) do
    @directions
    |> Enum.find_value(&match_coordinate_deltas(&1, {to_row - from_row, to_col - from_col}))
  end

  defp match_coordinate_deltas({direction, coord_deltas}, query_deltas) do
    coord_deltas == query_deltas && direction
  end

  defp find_winner({board, links}) do
    dimensions = get_dimensions(board)
    links
    |> Enum.find_value(fn {stone, stone_links} -> win?(stone, stone_links, dimensions) && stone end)
    |> name_winner()
  end

  defp win?("O", links, {last_row, _last_col}) do
    connects_top_to_bottom?(links, last_row)
  end

  defp win?("X", links, {_last_row, last_col}) do
    connects_left_to_right?(links, last_col)
  end

  defp get_dimensions(board) do
    {get_height(board), get_width(board)}
  end

  defp get_height(board) do
    Enum.max(Map.keys(board))
  end

  defp get_width(board) do
    board
    |> Enum.reduce(0, fn {_row, cols}, max_col -> max(max_col, Enum.max(Map.keys(cols))) end)
  end

  defp connects_top_to_bottom?(links, finish_line) do
    Stream.resource(
      fn -> {links, []} end,
      &traverse(&1, finish_line),
      &(&1)
    ) |> Enum.to_list()
    |> hd()
    |> Kernel.==(:win)
  end

  defp connects_left_to_right?(links, finish_line) do
    links
    |> transpose()
    |> connects_top_to_bottom?(finish_line)
  end

  def transpose(links) do
    links
    |> Enum.reduce(%{}, &transpose/2)
  end

  defp transpose({row, cols}, transposed) do
    Enum.reduce(cols, transposed, &transpose(&1, &2, row))
  end

  defp transpose({col, directions}, transposed, row) do
    directions = transpose_directions(directions)
    Map.update(transposed, col, %{row => directions}, &Map.put(&1, row, directions))
  end

  defp transpose_directions(directions) do
    Enum.map(directions, &@transposed_directions[&1])
  end

  defp traverse(:halt, _finish_line), do: {:halt, []}

  defp traverse({unvisited, stack}, finish_line) do
    if map_size(unvisited) == 0,
       do: {[:loss], :halt},
       else: visit_next(unvisited, stack, finish_line)
  end

  defp visit_next(unvisited, [], finish_line) do
    if is_map_key(unvisited, 0),
       do: visit_next(unvisited, [{0, unvisited[0] |> Map.keys() |> hd()}], finish_line),
       else: {[:loss], :halt}
  end

  defp visit_next(unvisited, [{row, col} | tail], finish_line) do
    if can_visit?(unvisited, row, col),
       do: visit_next(unvisited, row, col, tail, finish_line),
       else: visit_next(unvisited, tail, finish_line)
  end

  defp visit_next(unvisited, row, col, tail, finish_line) do
    if row == finish_line,
       do: {[:win], :halt},
       else: {[], {update_unvisited(unvisited, row, col), update_stack(unvisited, row, col, tail)}}
  end

  defp can_visit?(unvisited, row, col) do
    is_map_key(unvisited, row) and is_map_key(unvisited[row], col)
  end

  defp update_unvisited(unvisited, row, col) do
    if single_column?(unvisited, row),
       do: Map.drop(unvisited, [row]),
       else: Map.update!(unvisited, row, &Map.drop(&1, [col]))
  end

  defp single_column?(unvisited, row) do
    length(Map.keys(unvisited[row])) == 1
  end

  defp update_stack(unvisited, row, col, tail) do
    unvisited[row][col]
    |> Enum.reduce(tail, & [move_to(&1, row, col) | &2])
  end

  defp move_to(direction, row, col) do
    {row_delta, col_delta} = @directions[direction]
    {row + row_delta, col + col_delta}
  end

  defp name_winner(nil), do: :none
  defp name_winner("X"), do: :black
  defp name_winner("O"), do: :white
end
