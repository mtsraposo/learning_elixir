defmodule RPNCalculator.Exception do
  # Please implement DivisionByZeroError here.
  defmodule DivisionByZeroError do
    defexception message: "division by zero occurred"
  end

  # Please implement StackUnderflowError here.
  defmodule StackUnderflowError do
    defexception message: "stack underflow occurred"

    @impl true
    def exception(value) do
      case value do
        [] -> %StackUnderflowError{}
        _ -> %StackUnderflowError{message: "stack underflow occurred, context: #{value}"}
      end
    end
  end

  def divide([den | [num | _]]) when den == 0, do: raise DivisionByZeroError
  def divide([den | [num | _]]), do: num / den
  def divide([head]), do: raise StackUnderflowError, "when dividing"
  def divide([]), do: raise StackUnderflowError, "when dividing"

end
