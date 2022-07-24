defmodule RPG.CharacterSheet do
  def welcome() do
    IO.puts "Welcome! Let's fill out your character sheet together."
  end

  def ask_name() do
    IO.gets("What is your character's name?\n")
    |> String.trim()
  end

  def ask_class() do
    IO.gets("What is your character's class?\n")
    |> String.trim()
  end

  def ask_level() do
    IO.gets("What is your character's level?\n")
    |> String.trim()
    |> Integer.parse()
    |> elem(0)
  end

  def ask_and_save(attr, mp) do
    Map.put(mp,
      attr |> String.to_atom(),
      apply(__MODULE__, "ask_#{attr}" |> String.to_atom(), []))
  end

  def run() do
    welcome()
    Enum.reduce(["name", "class", "level"], %{}, &ask_and_save(&1, &2))
    |> IO.inspect(label: "Your character")
  end
end
