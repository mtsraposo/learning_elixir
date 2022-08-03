defmodule DiffieHellman do
  @base_limit 10**6
  @exp_limit 10**2

  @moduledoc """
  Diffie-Hellman is a method of securely exchanging keys in a public-key
  cryptosystem. Two users, Alice and Bob, want to share a secret between
  themselves, while ensuring nobody else can read it.

  Step 0: Alice and Bob agree on two prime numbers, P and G. An attacker, Eve,
  can intercept these numbers, but without one of Alice or Bob's private keys,
  we'll see Eve can't do anything useful with them.

  Step 1: Alice and Bob each generate a private key between 1 and P-1.
  P).

  Step 2: Using the initial primes P and G, Alice and Bob calculate their
  public keys by raising G to the power of their private key, then calculating
  the modulus of that number by P. ((G**private_key) % P)

  Step 3: Alice and Bob exchange public keys. Alice and Bob calculate a secret
  shared key by raising the other's public key to the power of their private
  key, then doing a modulus of the result by P. Due to the way modulus math
  works, they should both generate the same shared key.

  Alice calculates: (bob_public ** alice_private) % P
  Bob calculates: (alice_public ** bob_private) % P

  As long as their private keys are never lost or transmitted, only they know
  their private keys, so even if Eve has P, G, and both public keys, she can't
  do anything with them.

  A video example is available at:
  https://www.khanacademy.org/computing/computer-science/cryptography/modern-crypt/v/diffie-hellman-key-exchange-part-2
  """

  @doc """
  Given a prime integer `prime_p`, return a random integer between 1 and `prime_p` - 1
  """
  @spec generate_private_key(prime_p :: integer) :: integer
  def generate_private_key(prime_p)
      when prime_p < @base_limit do
    :rand.uniform(prime_p)
  end

  def generate_private_key(prime_p) do
    gen_large_random_integer(prime_p)
  end

  def gen_large_random_integer(n) do
    n
    |> Integer.digits()
    |> random_digits()
  end

  defp random_digits(digits) do
    [gen_first_digit(digits) | gen_last_digits(digits)]
    |> Integer.undigits()
  end

  defp gen_first_digit(digits) do
    (hd(digits) - 1)
    |> max(1)
    |> :rand.uniform()
    |> (& &1 - 1).()
  end

  defp gen_last_digits(digits) do
    digits
    |> Enum.drop(1)
    |> Enum.map(fn d -> :rand.uniform(max(1,d)) - 1 end)
  end

  @doc """
  Given two prime integers as generators (`prime_p` and `prime_g`), and a private key,
  generate a public key using the mathematical formula:

  (prime_g **  private_key) % prime_p
  """
  @spec generate_public_key(prime_p :: integer, prime_g :: integer, private_key :: integer) ::
          integer
  def generate_public_key(prime_p, prime_g, private_key)
      when prime_g < @base_limit and private_key < @exp_limit do
    rem(prime_g ** private_key, prime_p)
  end

  def generate_public_key(prime_p, prime_g, private_key) do
    rem_exp_large_numbers(prime_g, private_key, prime_p)
  end

  @doc """
  Given a prime integer `prime_p`, user B's public key, and user A's private key,
  generate a shared secret using the mathematical formula:

  (public_key_b ** private_key_a) % prime_p
  """
  @spec generate_shared_secret(
          prime_p :: integer,
          public_key_b :: integer,
          private_key_a :: integer
        ) :: integer
  def generate_shared_secret(prime_p, public_key_b, private_key_a)
      when public_key_b < @base_limit and private_key_a < @exp_limit do
    rem(public_key_b ** private_key_a, prime_p)
  end

  def generate_shared_secret(prime_p, public_key_b, private_key_a) do
    rem_exp_large_numbers(public_key_b, private_key_a, prime_p)
  end

  defp rem_exp_large_numbers(base, exponent, modulus) do
    rem_exp_large_numbers(base, exponent, modulus, 1)
  end

  defp rem_exp_large_numbers(_base, 0, _modulus, rest) do
    rest
  end

  defp rem_exp_large_numbers(base, exponent, modulus, rest) do
    {base, exponent, rest} = update_args(base, exponent, modulus, rest)
    rem_exp_large_numbers(base, exponent, modulus, rest)
  end

  defp update_args(base, exponent, modulus, rest) do
    rest = if(rem(exponent, 2) == 1, do: rem(rest * base, modulus), else: rest)
    base = rem(base ** 2, modulus)
    exponent = div(exponent, 2)
    {base, exponent, rest}
  end

end
