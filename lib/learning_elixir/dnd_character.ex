defmodule DndCharacter do
  @type t :: %__MODULE__{
               strength: pos_integer(),
               dexterity: pos_integer(),
               constitution: pos_integer(),
               intelligence: pos_integer(),
               wisdom: pos_integer(),
               charisma: pos_integer(),
               hitpoints: pos_integer()
             }

  defstruct ~w[strength dexterity constitution intelligence wisdom charisma hitpoints]a

  @spec character :: t()
  def character do
    assign_abilities()
    |> calc_hitpoints()
    |> (&struct(DndCharacter, &1)).()
  end

  defp assign_abilities() do
    for k <- Map.keys(%DndCharacter{}), into: %{} do
      {k, ability()}
    end
  end

  @spec ability :: pos_integer()
  def ability do
    roll_dice()
    |> sum_largest(3)
  end

  defp roll_dice() do
    Enum.map(1..6, fn _ -> Enum.random(1..6) end)
  end

  defp sum_largest(dice, n) do
    dice
    |> Enum.sort()
    |> Enum.take(-n)
    |> Enum.sum()
  end

  defp calc_hitpoints(character) do
    %{character | hitpoints: 10 + modifier(character.constitution)}
  end

  @spec modifier(pos_integer()) :: integer()
  def modifier(score) do
    floor((score - 10) / 2)
  end


end
