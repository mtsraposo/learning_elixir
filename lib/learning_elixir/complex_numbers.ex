defmodule ComplexNumbers do
  import Kernel, except: [abs: 1, div: 2]

  @typedoc """
  In this module, complex numbers are represented as a tuple-pair containing the real and
  imaginary parts.
  For example, the real number `1` is `{1, 0}`, the imaginary number `i` is `{0, 1}` and
  the complex number `4+3i` is `{4, 3}'.
  """
  @type complex :: {float, float}

  @doc """
  Return the real part of a complex number
  """
  @spec real(a :: complex) :: float
  def real({r, _i}) do
    r
  end

  @doc """
  Return the imaginary part of a complex number
  """
  @spec imaginary(a :: complex) :: float
  def imaginary({_r, i}) do
    i
  end

  @doc """
  Multiply two complex numbers, or a real and a complex number
  """
  @spec mul(a :: complex | float, b :: complex | float) :: complex
  def mul({a_r, a_i}, {b_r, b_i}) do
    {a_r * b_r - a_i * b_i, a_r * b_i + a_i * b_r}
  end

  def mul({a_r, a_i}, b) do
    {a_r * b, a_i * b}
  end

  def mul(a, {b_r, b_i}) do
    {a * b_r, a * b_i}
  end

  @doc """
  Add two complex numbers, or a real and a complex number
  """
  @spec add(a :: complex | float, b :: complex | float) :: complex
  def add({a_r, a_i}, {b_r, b_i}) do
    {a_r + b_r, a_i + b_i}
  end

  def add({a_r, a_i}, b) do
    {a_r + b, a_i}
  end

  def add(a, {b_r, b_i}) do
    {a + b_r, b_i}
  end

  @doc """
  Subtract two complex numbers, or a real and a complex number
  """
  @spec sub(a :: complex | float, b :: complex | float) :: complex
  def sub({a_r, a_i}, {b_r, b_i}) do
    {a_r - b_r, a_i - b_i}
  end

  def sub({a_r, a_i}, b) do
    {a_r - b, a_i}
  end

  def sub(a, {b_r, b_i}) do
    {a - b_r, -b_i}
  end

  @doc """
  Divide two complex numbers, or a real and a complex number
  """
  @spec div(a :: complex | float, b :: complex | float) :: complex
  def div({a_r, a_i} = a, {b_r, b_i} = b) do
    a
    |> mul(conjugate(b))
    |> div(abs(b) ** 2)
  end

  def div({a_r, a_i}, b) do
    {a_r / b,
      a_i / b}
  end

  def div(a, {b_r, b_i}) do
    div({a, 0}, {b_r, b_i})
  end

  @doc """
  Absolute value of a complex number
  """
  @spec abs(a :: complex) :: float
  def abs({r, i}) do
    (r**2 + i**2) ** 0.5
  end

  @doc """
  Conjugate of a complex number
  """
  @spec conjugate(a :: complex) :: complex
  def conjugate({r, i}) do
    {r, -i}
  end

  @doc """
  Exponential of a complex number
  """
  @spec exp(a :: complex) :: complex
  def exp({r, i}) do
    :math.exp(r)
    |> mul({:math.cos(i), :math.sin(i)})
  end

end
