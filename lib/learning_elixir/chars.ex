defmodule Username do
  def sanitize(username) do
    Enum.map_join(username,
      fn c -> case c do
                ?ä -> "ae"
                ?ö -> "oe"
                ?ü -> "ue"
                ?ß -> "ss"
                c when c in ?a..?z or c == ?_ -> List.to_string([c])
                _ -> ""
              end
      end)
    |> String.to_charlist()
  end
end
