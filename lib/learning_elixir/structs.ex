defmodule RemoteControlCar do
  @enforce_keys [:nickname]
  defstruct [:battery_percentage, :distance_driven_in_meters, :nickname]

  def new(), do: %RemoteControlCar{battery_percentage: 100, distance_driven_in_meters: 0, nickname: "none"}

  def new(nickname), do: %{new() | nickname: nickname}

  def display_distance(remote_car) when is_struct(remote_car, RemoteControlCar), do: "#{remote_car.distance_driven_in_meters} meters"

  def display_battery(remote_car) when is_struct(remote_car, RemoteControlCar) do
    cond do
      remote_car.battery_percentage > 0 -> "Battery at #{remote_car.battery_percentage}%"
      true -> "Battery empty"
    end
  end

  def drive(remote_car) when is_struct(remote_car, RemoteControlCar) and remote_car.battery_percentage == 0, do: remote_car
  def drive(remote_car) when is_struct(remote_car, RemoteControlCar) and remote_car.battery_percentage > 0 do
    remote_car
    |> (&(%{&1 | battery_percentage: &1.battery_percentage - 1})).()
    |> (&(%{&1 | distance_driven_in_meters: &1.distance_driven_in_meters + 20})).()
  end
end
