defmodule Grep do
  @spec grep(String.t(), [String.t()], [String.t()]) :: String.t()
  def grep(pattern, flags, files) do
    if "-l" not in flags,
       do: return_matches(pattern, flags, files),
       else: return_files_matching_at_least_one_line(pattern, flags, files)
  end

  defp return_matches(pattern, flags, files) do
    files
    |> Enum.map(fn file -> {file, file |> read_and_match(pattern, flags)} end)
    |> Enum.map(fn {file, matches} -> if(length(files) > 1,
                                        do: prepend_file_name(file, matches),
                                        else: matches) end)
    |> Enum.join()
  end

  defp read_and_match(file, pattern, flags) do
    Stream.resource(
      fn -> {File.open!(file, [:read]), 1} end,
      fn {pid, line} -> read_and_match(pid, line, pattern, flags) end,
      fn pid -> File.close(pid) end
    )
    |> Enum.to_list()
  end

  defp read_and_match(pid, line, pattern, flags) do
    case IO.read(pid, :line) do
      data when data |> is_binary() -> {match(data, line, pattern, flags), {pid, line+1}}
      _ -> {:halt, pid}
    end
  end

  defp match(data, line, pattern, flags) do
    if data |> matches?(pattern, flags),
       do: [return_match(flags, data, line)],
       else: []
  end

  defp matches?(data, pattern, flags) do
    pattern = from_flags(pattern, flags)
    if "-v" in flags,
       do: not Regex.match?(pattern, data),
       else: Regex.match?(pattern, data)
  end

  defp from_flags(pattern, []) do
    ~r".*#{pattern}.*"
  end

  defp from_flags(pattern, flags) do
    pattern = if("-x" in flags, do: "^#{pattern}$", else: pattern)
    opts = if("-i" in flags, do: [:caseless], else: [])
    {:ok, pattern} = Regex.compile(pattern, opts)
    pattern
  end

  defp return_match(flags, data, line) do
    if "-n" in flags,
       do: "#{line}:#{data}",
       else: data
  end

  defp prepend_file_name(file, matches) do
    matches
    |> Enum.map(fn match -> "#{file}:#{match}" end)
  end

  defp return_files_matching_at_least_one_line(pattern, flags, files) do
    files
    |> Enum.map(fn file -> file |> read_until_match_or_eof(pattern, flags) end)
    |> return_file_names()
  end

  defp read_until_match_or_eof(file, pattern, flags) do
    Stream.resource(
      fn -> File.open!(file, [:read]) end,
      fn pid -> pid |> match_or_eof?(file, pattern, flags) end,
      fn pid -> File.close(pid) end
    )
    |> Enum.to_list()
  end

  defp match_or_eof?({:halt, pid}, _file, _pattern, _flags) do
    {:halt, pid}
  end

  defp match_or_eof?(pid, file, pattern, flags) do
    case IO.read(pid, :line) do
      data when is_binary(data) -> if data |> matches?(pattern, flags),
                                      do: {[file], {:halt, pid}},
                                      else: {[], pid}
      _ -> {:halt, pid}
    end
  end

  defp return_file_names(matches) do
    matches
    |> Enum.filter(fn name -> not Enum.empty?(name) end)
    |> Enum.map(fn [file] -> "#{file}\n" end)
    |> Enum.join()
  end
end
