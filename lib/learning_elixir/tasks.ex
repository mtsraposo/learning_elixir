defmodule RPNCalculatorInspection do
  def start_reliability_check(calculator, input) do
    %{input: input,
      pid: spawn_link(fn -> calculator.(input) end)}
  end

  def await_reliability_check_result(%{pid: pid, input: input}, results) do
    Map.put(results, input, receive do
      {:EXIT, ^pid, :normal} -> :ok
      {:EXIT, ^pid, _} -> :error
    after 100 -> :timeout
    end)
  end

  def reliability_check(calculator, inputs) do
    old_flag = Process.flag(:trap_exit, true)
    checks = inputs
             |> Enum.map(fn input -> start_reliability_check(calculator, input) end)
             |> Enum.reduce(%{}, fn check, results -> await_reliability_check_result(check, results) end)
    Process.flag(:trap_exit, old_flag)
    checks
  end

  def correctness_check(calculator, inputs) do
    inputs
    |> Enum.map(fn input -> Task.async(fn -> calculator.(input) end) end)
    |> Enum.map(fn task -> Task.await(task, 100) end)
  end
end
