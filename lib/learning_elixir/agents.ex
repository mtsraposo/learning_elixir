defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(opts \\ []) do
    Agent.start(fn -> 0 end, name: :id_counter)
    Agent.start(fn -> [] end)
  end

  def list_registrations(pid), do: Agent.get(pid, fn state -> state end)

  def register(pid, register_to) do
    new_plot = %Plot{plot_id: last_plot_id + 1, registered_to: register_to}
    Agent.update(pid, fn state -> [new_plot | state] end)
    new_plot
  end

  defp last_plot_id(), do: Agent.get_and_update(:id_counter, fn state -> {state, state + 1} end)

  def release(pid, plot_id), do: Agent.update(pid, fn state -> Enum.reject(state, & &1.plot_id == plot_id) end)

  def get_registration(pid, plot_id), do: Agent.get(pid, fn state -> get_plot_by_id(state, plot_id) end)

  defp get_plot_by_id(plots, plot_id), do: Enum.find(plots, &((&1).plot_id == plot_id)) || {:not_found, "plot is unregistered"}
end