defmodule TopSecret do
  def to_ast(string), do: Code.string_to_quoted!(string)

  def decode_secret_message_part(ast, acc) do
    {ast, parse(ast, acc)}
  end

  defp parse({:def, _meta, fun}, acc), do: parse(fun, acc)
  defp parse({:defp, _meta, fun}, acc), do: parse(fun, acc)
  defp parse([{:when, _meta, [{name, _, args}, _cond]}, _body], acc), do: [decode_function_name(name, args) | acc]
  defp parse([{name, _, args}, _body], acc), do: [decode_function_name(name, args) | acc]
  defp parse(_, acc), do: acc

  defp decode_function_name(fun_name, args) when args == nil, do: ""
  defp decode_function_name(fun_name, args) do
    length = max(0,Enum.count(args))
    fun_name
    |> Atom.to_string()
    |> String.slice(0, length)
  end

  def decode_secret_message(string) do
    string
    |> to_ast()
    |> Macro.prewalk([], &decode_secret_message_part(&1, &2))
    |> elem(1)
    |> Enum.reverse()
    |> Enum.join()
  end
end