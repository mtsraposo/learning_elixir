defmodule RobotSimulator do
  @type robot() :: map()
  @type direction() :: :north | :east | :south | :west
  @type position() :: {integer(), integer()}

  @directions %{north: 0, east: 1, south: 2, west: 3}
  @instructions %{"L" => -1, "A" => 0, "R" => 1}

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction, position) :: robot() | {:error, String.t()}
  def create(direction \\ nil, position \\ nil)
  def create(nil, nil), do: %{direction: :north, position: {0,0}}
  def create(direction, position) do
    with {:ok, direction} <- validate_direction(direction),
         {:ok, position} <- validate_position(position) do
      %{direction: direction, position: position}
    else
      {:error, message} -> {:error, message}
    end
  end

  defp validate_direction(direction) do
    if is_map_key(@directions, direction),
       do: {:ok, direction},
       else: {:error, "invalid direction"}
  end

  defp validate_position(position) do
    with true <- is_tuple(position),
         2 <- position |> Tuple.to_list() |> length(),
         {x, y} <- position,
         true <- is_integer(x),
         true <- is_integer(y) do
      {:ok, position}
    else
      _ -> {:error, "invalid position"}
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  @spec simulate(robot, instructions :: String.t()) :: robot() | {:error, String.t()}
  def simulate(robot, instructions) do
    if valid_instructions?(instructions),
       do: instructions |> String.graphemes() |> Enum.reduce(robot, &move(&2, &1)),
       else: {:error, "invalid instruction"}
  end

  defp valid_instructions?(instructions) do
    String.match?(instructions, ~r"^[ALR]+$")
  end

  defp move(%{direction: dir, position: pos}, instruction) do
    dir
    |> update_direction(instruction)
    |> update_position(pos, instruction)
  end

  defp update_direction(direction, instruction) do
    get_direction_id(direction)
    |> calc_new_direction_id(instruction)
    |> find_direction_by_id()
  end

  defp get_direction_id(dir) do
    @directions[dir]
  end

  defp calc_new_direction_id(id, instruction) do
    Stream.cycle(0..3)
    |> Enum.at(4 + @instructions[instruction] + id)
  end

  defp find_direction_by_id(id) do
    @directions
    |> Enum.find_value(fn {dir, i} -> i == id && dir end)
  end

  defp update_position(dir, pos, "A"), do: create(dir, advance(dir, pos))
  defp update_position(dir, pos, _), do: create(dir, pos)

  defp advance(:north, {x, y}), do: {x, y + 1}
  defp advance(:east, {x, y}), do: {x + 1, y}
  defp advance(:south, {x, y}), do: {x, y - 1}
  defp advance(:west, {x, y}), do: {x - 1, y}

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec direction(robot) :: direction()
  def direction(robot), do: robot.direction

  @doc """
  Return the robot's position.
  """
  @spec position(robot) :: position()
  def position(robot), do: robot.position
end
