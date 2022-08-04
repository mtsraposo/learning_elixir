defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  defmodule Link do
    def chain(dominoes), do: dominoes |> Enum.reduce(%{}, &link/2)

    defp link({l, r}, links) when l == r do
      links
      |> do_link({l, r})
    end

    defp link({l, r}, links) do
      links
      |> do_link({l, r})
      |> do_link({r, l})
    end

    defp do_link(links, {l, r}) do
      {_right, links} = Map.get_and_update(links, l, fn right -> increment(right, r) end)
      links
    end

    defp increment(nil, elem), do: {:ok, %{elem => 1}}

    defp increment(map, elem) do
      {_count, map} = Map.get_and_update(map, elem, &increment/1)
      {:ok, map}
    end

    defp increment(nil), do: {:ok, 1}

    defp increment(count), do: {:ok, count + 1}
  end

  defmodule Graph do
    def is_cyclic?(links) when map_size(links) == 0, do: true

    def is_cyclic?(links) do
      first = hd(Map.keys(links))
      from = first
      is_cyclic?(links, from, first)
    end

    def is_cyclic?(links, from, first)
        when map_size(links) == 0 do
      from == first
    end

    def is_cyclic?(links, from, first) do
      if Map.get(links, from) == nil,
         do: false,
         else: traverse(links, from, first)
    end

    defp traverse(links, from, first) do
      Map.get(links, from)
      |> Enum.reduce_while(false, fn {to, count}, stop? -> links
                                                           |> remove_link!(from, {to, count})
                                                           |> is_cyclic?(to, first)
                                                           |> return_or_halt() end)
    end

    defp return_or_halt(true), do: {:halt, true}
    defp return_or_halt(false), do: {:cont, false}

    defp remove_link!(links, from, {to, count})
         when from == to do
      links
      |> remove_segment!(from, {to, count})
    end

    defp remove_link!(links, from, {to, count}) do
      links
      |> remove_segment!(from, {to, count})
      |> remove_segment!(to, {from, links |> Map.get(to) |> Map.get(from)})
    end

    defp remove_segment!(links, from, {to, count}) do
      if has_single_link?(links, from) do
        remove_segment!(links, from)
      else
        update_segment(links, from, {to, count})
      end
    end

    defp has_single_link?(links, from) do
      links
      |> Map.get(from)
      |> (& map_size(&1) == 1 and hd(Map.values(&1)) == 1).()
    end

    defp remove_segment!(map, to) do
      {_elem, map} = Map.pop!(map, to)
      map
    end

    defp update_segment(links, from, {to, count}) do
      {_right, links} = Map.get_and_update!(links, from, fn right -> {right, update_segment(right, {to, count})} end)
      links
    end

    defp update_segment(right, {to, 1}) do
      remove_segment!(right, to)
    end

    defp update_segment(right, {to, count}) do
      decrement!(right, {to, count})
    end

    defp decrement!(right, {to, _count}) do
      Map.update!(right, to, fn count -> count - 1 end)
    end

  end

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino]) :: boolean
  def chain?(dominoes) do
    dominoes
    |> Link.chain()
    |> Graph.is_cyclic?()
  end

end