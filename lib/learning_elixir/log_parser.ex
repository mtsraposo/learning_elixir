defmodule LogParser do
  def valid_line?(line) do
    line =~ ~r"^\[(DEBUG|INFO|WARNING|ERROR)].*"
  end

  def split_line(line) do
    Regex.split(~r"<[\~\*\=\-]*>", line)
  end

  def remove_artifacts(line) do
    Regex.replace(~r"end-of-line(\d+)"i, line, "")
  end

  def tag_with_user_name(line) do
    case Regex.scan(~r"User\s+(.+?)(\s+|$)", line) do
      [[_group, name, _end]] -> "[USER] #{name} #{line}"
      [] -> line
    end
  end
end
