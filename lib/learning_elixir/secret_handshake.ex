defmodule SecretHandshake do
  @bit_handshake %{
    0 => "wink",
    1 => "double blink",
    2 => "close your eyes",
    3 => "jump"
  }

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    code
    |> Integer.digits(2)
    |> Enum.reverse()
    |> Stream.with_index()
    |> Enum.reduce([], &prepend_handshake/2)
    |> Enum.reverse()
  end

  defp prepend_handshake({0, bit}, handshakes) do
    handshakes
  end

  defp prepend_handshake({1, 4}, handshakes) do
    Enum.reverse(handshakes)
  end

  defp prepend_handshake({1, bit}, handshakes)
       when bit in [0,1,2,3] do
    [Map.get(@bit_handshake, bit) | handshakes]
  end

  defp prepend_handshake({1, bit}, handshakes) do
    handshakes
  end

end
