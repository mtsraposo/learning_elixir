defmodule Markdown do
  @doc ~S"""
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

      iex> Markdown.parse("This is a paragraph")
      "<p>This is a paragraph</p>"

      iex> Markdown.parse("# Header!\\n* __Bold Item__\\n* _Italic Item_")
      "<h1>Header!</h1><ul><li><strong>Bold Item</strong></li><li><em>Italic Item</em></li></ul>""
  """

  @patterns %{
    header: ~r"^([\#]{1,6})\s(.*)$",
    list_item: ~r"^([\*])\s(.*)$",
    bold: ~r"[\_]{2}(.*?)[\_]{2}",
    italic: ~r"[\_]([^\_].*?[^\_])[\_]",
    list: ~r"((<li>.+?</li>)+)"
  }

  @tags %{
    header: "h",
    list_item: "li",
    default: "p"
  }

  @spec parse(String.t()) :: String.t()
  def parse(markdown) do
    markdown
    |> String.split("\n")
    |> Enum.map(&process/1)
    |> Enum.join()
    |> enclose_lists()
  end

  defp process(line) do
    cond do
      String.match?(line, @patterns[:header]) -> process(line, :header)
      String.match?(line, @patterns[:list_item]) -> process(line, :list_item)
      true -> process(line, :default)
    end
  end

  defp process(line, tag) do
    line
    |> parse(tag)
    |> append_tag(tag)
    |> gen_element()
  end

  defp parse(line, element)
       when is_map_key(@patterns, element) do
    [[_, id_char, content]] = Regex.scan(@patterns[element], line)
    {id_char, content}
  end

  defp parse(line, element), do: {element, line}

  defp append_tag({id_char, content}, :header) do
    {content, "#{@tags[:header]}#{String.length(id_char)}"}
  end

  defp append_tag({_, content}, element) do
    {content, @tags[element]}
  end

  defp gen_element({content, tag}) do
    content
    |> replace_emphasis_modifiers()
    |> enclose_with_tag(tag)
  end

  defp replace_emphasis_modifiers(content) do
    content
    |> String.replace(@patterns[:bold], "<strong>\\\1</strong>")
    |> String.replace(@patterns[:italic], "<em>\\\1</em>")
  end

  defp enclose_with_tag(content, element) do
    "<#{element}>#{content}</#{element}>"
  end

  defp enclose_lists(text) do
    text
    |> String.replace(@patterns[:list], "<ul>\\\1</ul>")
  end
end
