defmodule School do
  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @type school :: %{String.t() => pos_integer()}

  @doc """
  Create a new, empty school.
  """
  @spec new() :: school
  def new() do
    %{}
  end

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(school, String.t(), integer) :: {:ok | :error, school}
  def add(school, name, grade) do
    if student_enrolled?(school, name, grade) do
      {:error, school}
    else
      {:ok, do_add(school, grade, name)}
    end
  end

  defp student_enrolled?(school, name, grade) do
    Map.get(school, name) != nil
  end

  defp do_add(school, grade, name) do
    Map.put(school, name, grade)
  end

  @doc """
  Return the names of the students in a particular grade, sorted alphabetically.
  """
  @spec grade(school, integer) :: [String.t()]
  def grade(school, grade) do
    school
    |> Stream.filter(fn {_name, g} -> g == grade end)
    |> sort_by_name()
  end

  @doc """
  Return the names of all the students in the school sorted by grade and name.
  """
  @spec roster(school) :: [String.t()]
  def roster(school) do
    school
    |> sort_by_grade()
    |> Enum.map(&sort_by_name/1)
    |> List.flatten()
  end

  defp sort_by_grade(school) do
    school
    |> Enum.group_by(fn {_name, grade} -> grade end)
    |> Enum.sort()
  end

  defp sort_by_name([]), do: []

  defp sort_by_name({_grade, names_to_grades}) do
    sort_by_name(names_to_grades)
  end

  defp sort_by_name(names_to_grades) do
    names_to_grades
    |> Stream.map(fn {name, _grade} -> name end)
    |> Enum.sort()
  end

end
