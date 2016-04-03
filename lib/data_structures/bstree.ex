defmodule Exads.DataStructures.BSTree do
  @moduledoc """
  Binary Search Tree with tuples.
  """

  @typedoc """
  Tree node.
  """
  @type bst :: :leaf | {bst, any, bst}

  @spec empty?(bst) :: boolean
  def empty?(:leaf), do: true
  def empty?(_), do: false

  @spec contains?(bst, any) :: boolean
  def contains?(:leaf, _), do: false
  def contains?({left, value, right}, val) do
    cond do
      val == value -> true
      val <  value -> contains?(left, val)
      val >  value -> contains?(right, val)
    end
  end


  @doc """
  Alias of contains?
  """
  @spec exists?(bst, any) :: boolean
  def exists?(t, v), do: contains?(t, v)

  @spec new(any) :: bst
  def new(), do: :leaf
  def new(val), do: {:leaf, val, :leaf}

  @spec insert(bst, any) :: bst
  def insert(:leaf, val), do: {:leaf, val, :leaf}
  def insert({left, value, right}, val) do
    cond do
      val == value -> {left, val, right}
      val <  value -> {insert(left, val), value, right}
      val >  value -> {left, value, insert(right, val)}
    end
  end

  defp del(:leaf) do :leaf end
  defp del({:leaf, _, :leaf}), do: :leaf
  defp del({:leaf, _, right}), do: right
  defp del({left, _, :leaf}), do: left
  defp del({left, _, right}) do
    m = min(right)
    {left, m, delete(right, m)}
  end

  defp min({:leaf, val, _}), do: val
  defp min({left, _, _}), do: min(left)

  @spec delete(bst, any) :: bst
  def delete(:leaf), do: :leaf
  def delete({left, value, right}, val) do
    cond do
      val == value -> del({left, value, right})
      val <  value -> {delete(left, val), value, right}
      val >  value -> {left, value, delete(right, val)}
    end
  end

  def inorder(:leaf), do: []
  def inorder({left, value, right}) do
    inorder(left) ++ [value] ++ inorder(right)
  end

  def preorder(:leaf), do: []
  def preorder({left, value, right}) do
    [value] ++ preorder(left) ++ preorder(right)
  end

  def postorder(:leaf), do: []
  def postorder({left, value, right}) do
    postorder(left) ++ postorder(right) ++ [value]
  end

  defp bfs([]), do: []
  defp bfs(list) do
    children = Enum.map(list, fn x ->
      case x do
        :leaf -> []
        {:leaf, _, :leaf} -> []
        {left,  _, :leaf} -> [left]
        {:leaf, _, right} -> [right]
        {left,  _, right} -> [left, right]
      end
    end) |> List.flatten
    list ++ bfs(children)
  end

  def breadth_first(:leaf), do: []
  def breadth_first(tree) do
    bfs([tree]) |> Enum.map(fn {_, value, _} -> value end)
  end

  @doc """
  Finds the node with the provided 'node_value' or nil if it does not
  exist in the tree.
  """
  @spec find_node(bst, any) :: %{} | nil

  def find_node(:leaf, _), do: nil
  def find_node(node = {_, value, _}, value), do: node
  def find_node({left, value, right}, val) do
    if val < value do
      find_node left, val
    else
      find_node right, val
    end
  end

  @doc """
  Find parent node, or nil if it does not exist.
  """
  def find_parent(:leaf, _), do: nil
  def find_parent(node = {_, value, _}, value), do: node
  def find_parent(node = {left, value, right}, val) do
    if ((left != :leaf and elem(left, 1) == val) or
        (right != :leaf and elem(right, 1) == val)) do
      node
    else
      if val < value do
        find_parent(left, val)
      else
        find_parent(right, val)
      end
    end
  end

  @doc """
  Finds the depth of the node with the given 'node_value', or -1 if not found.
  """
  @spec node_depth(bst | nil, any) :: integer
  def node_depth(tree, val), do: nd tree, val, 0

  defp nd(:leaf, _, _), do: -1
  defp nd({_, val, _}, val, depth), do: depth
  defp nd({l, v, r}, val, depth) do
    if val < v do
      nd l, val, depth + 1
    else
      nd r, val, depth + 1
    end
  end

  @spec tree_height(bst) :: integer
  def tree_height(:leaf), do: 0
  def tree_height(tree) do
    th(tree, 0, 0)
  end

  defp th(:leaf, depth, max) do
    if depth > max do depth else max end
  end

  defp th({left, _, right}, depth, max) do
    lmax = th(left, depth + 1, max)
    rmax = th(right, depth + 1, max)
    if lmax > max do lmax else max end
    if rmax > max do rmax else max end
  end

end
