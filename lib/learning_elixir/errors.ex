defmodule RPNCalculator do
  def calculate!(stack, operation), do: operation.(stack)

  def calculate(stack, operation) do
    try do
      calculate!(stack, operation)
      {:ok, "operation completed"}
    rescue
      _ -> :error
    end
  end

  def calculate_verbose(stack, operation) do
    try do
      calculate!(stack, operation)
      {:ok, "operation completed"}
    rescue
      e in _ -> {:error, e.message}
    end
  end
end
