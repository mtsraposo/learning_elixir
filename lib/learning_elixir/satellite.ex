defmodule Satellite do
  @typedoc """
  A tree, which can be empty, or made from a left branch, a node and a right branch
  """
  @type tree :: {} | {tree, any, tree}

  @doc """
  Build a tree from the elements given in a pre-order and in-order style
  """
  @spec build_tree(preorder :: [any], inorder :: [any]) :: {:ok, tree} | {:error, String.t()}

  def build_tree(preorder, inorder) do
    with :ok <- same_length?(preorder, inorder),
         {:ok, preorder_elements, inorder_elements} <- unique_elements?(preorder, inorder),
         {:ok, elements} <- equal_elements?(preorder_elements, inorder_elements) do
      {:ok, find_subtree_split_point({preorder, inorder}) |> build_tree()}
    else
      {:error, message} -> {:error, message}
    end
  end

  defp same_length?(preorder, inorder) do
    if length(preorder) == length(inorder),
       do: :ok,
       else: {:error, "traversals must have the same length"}
  end

  defp unique_elements?(preorder, inorder) do
    with {:ok, preorder_elements} <- unique_elements?(preorder),
         {:ok, inorder_elements} <- unique_elements?(inorder) do
      {:ok, preorder_elements, inorder_elements}
    else
      {:error, message} -> {:error, message}
    end
  end

  defp unique_elements?(list) do
    with false <- Enum.reduce_while(list, MapSet.new(), &append_if_not_seen_before/2) do
      {:error, "traversals must contain unique items"}
    else
      elements -> {:ok, elements}
    end
  end

  defp append_if_not_seen_before(elem, set) do
    if elem not in set,
       do: {:cont, MapSet.put(set, elem)},
       else: {:halt, false}
  end

  defp equal_elements?(preorder_elements, inorder_elements) do
    if MapSet.equal?(preorder_elements, inorder_elements),
       do: {:ok, preorder_elements},
       else: {:error, "traversals must have the same elements"}
  end

  defp find_subtree_split_point({preorder, inorder}) do
    {preorder, inorder, Enum.find_index(inorder, & &1 == get_root(preorder))}
  end

  defp build_tree({[], [], nil}), do: {}
  defp build_tree({[root], [root], 0}), do: {{}, root, {}}

  defp build_tree({preorder, inorder, left_size} = traversals) do
    {build_left_subtree(traversals),
      get_root(preorder),
      build_right_subtree(traversals)}
  end

  defp build_left_subtree(traversals) do
    traversals
    |> split_left()
    |> find_subtree_split_point()
    |> build_tree()
  end

  defp split_left({preorder, inorder, left_size}) do
    left_preorder = Enum.slice(preorder, 1..left_size)
    left_inorder = Enum.slice(inorder, 0..(left_size-1))
    {left_preorder, left_inorder}
  end

  defp get_root(preorder), do: hd(preorder)

  defp build_right_subtree(traversals) do
    traversals
    |> split_right()
    |> find_subtree_split_point()
    |> build_tree()
  end

  defp split_right({preorder, inorder, left_size}) do
    right_preorder = Enum.slice(preorder, (left_size + 1)..-1)
    right_inorder = Enum.slice(inorder, (left_size + 1)..-1)
    {right_preorder, right_inorder}
  end
end
