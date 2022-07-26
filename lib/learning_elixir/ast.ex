defmodule TopSecret do
  def to_ast(string), do: Code.string_to_quoted(string) |> elem(1)

  def decode_secret_message_part(ast, acc) do
    {ast, cond do
      elem(ast, 0) in [:defp, :def] -> [decode_function_name(ast) | acc]
      true -> acc
    end}
  end

  defp decode_function_name({:def, _, fun} = _ast), do: decode_function_name(fun)

  defp decode_function_name({:defp, _, fun} = _ast), do: decode_function_name(fun)

  defp decode_function_name({:when, _, [header, _]} = _guard), do: decode_function_name(header)

  defp decode_function_name([header, _] = _fun), do: decode_function_name(header)

  defp decode_function_name({name, _, args} = _header), do: decode_function_name(name, args)

  defp decode_function_name(fun_name, args) do
    fun_name
    |> Atom.to_string()
    |> String.slice(0, max(0,Enum.count(args || [])))
  end

  def decode_secret_message(string) when is_binary(string), do: decode_secret_message(to_ast(string))

  def decode_secret_message({:__block__, _, body} = _ast) do
    body
    |> Enum.map(&decode_secret_message(&1))
    |> Enum.join()
  end

  def decode_secret_message({:defmodule, _, module} = _body), do: decode_secret_message(module)

  def decode_secret_message([_, [do: functions]] = _module), do: decode_secret_message(functions)

  def decode_secret_message({:def, _, fun} = _function), do: decode_function_name(fun)

  def decode_secret_message({:defp, _, fun} = _function), do: decode_function_name(fun)

end
