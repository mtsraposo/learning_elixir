defmodule Garden do
  @student_names ~w(alice bob charlie david eve fred ginny harriet ileana joseph kincaid larry)a

  @acronyms %{
    "G" => :grass,
    "C" => :clover,
    "R" => :radishes,
    "V" => :violets
  }

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @student_names) do
    info_string
    |> parse()
    |> Enum.map(&plants_to_students(&1, student_names))
    |> Enum.reduce([], &merge_rows/2)
    |> Enum.map(&acronyms_to_names/1)
    |> to_map(student_names)
  end

  defp parse(info_string) do
    info_string
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.chunk_every(&1, 2))
  end

  defp plants_to_students(row, student_names) do
    student_names = Enum.sort(student_names)
    Enum.zip_with([row, student_names], fn [plants, name] -> {name, plants} end)
  end

  defp merge_rows(row, merged) do
    Keyword.merge(merged, row, fn _k, v1, v2 -> v1 ++ v2 end)
  end

  defp acronyms_to_names({student, plants}) do
    {student, acronyms_to_names(plants)}
  end

  defp acronyms_to_names(plants) do
    Enum.map(plants, &Map.get(@acronyms, &1))
    |> List.to_tuple()
  end

  defp to_map(garden_info, student_names) do
    student_names
    |> Enum.map(&{&1, {}})
    |> Map.new()
    |> Map.merge(Map.new(garden_info))
  end
end
