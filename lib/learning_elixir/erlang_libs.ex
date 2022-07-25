defmodule CaptainsLog do
  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  def random_planet_class(), do: Enum.random(@planetary_classes)

  def random_ship_registry_number(), do: "NCC-#{999 + :rand.uniform(9000)}"

  def random_stardate(), do: 41000 + :rand.uniform * 1000

  def format_stardate(stardate), do: :io_lib.format("~.1.0f", [stardate]) |> List.to_string()
end
