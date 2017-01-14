defmodule Exads.DataStructures.BinarySearchTree do
  import Kernel, except: [{:>, 2}, {:<, 2}]

  @moduledoc """
  An implementation of the Binary Search Tree abstract data structure
  using Map.
  """

  @doc """
  Comparable protocoll which needs to be implemented for all BST values
  """

  defprotocol Comparable do
    @fallback_to_any true
    @dialyzer {:nowarn_function, __protocol__: 1}

    @moduledoc """
    Comparable definition for BST nodes
    Needs to be implemented for the value of the BST node
    """

    @doc """
      Implementation of greater for BST comparisons
    """
    @spec any > any :: boolean
    def left > right

    @doc """
       Implementation of less for BST comparisons
    """
    @spec any < any :: boolean
    def left < right

  end

  defimpl Comparable, for: Any do
    def left > right, do: Kernel.>(left, right)
    def left < right, do: Kernel.<(left, right)
  end

  def left < right do
    Comparable.<(left, right)
  end

  def left > right do
    Comparable.>(left, right)
  end

  defmodule Node do

    @moduledoc """
    A BST Node
    """

    @type bst_node :: %__MODULE__{value: any, left: :leaf | bst_node, right: :leaf | bst_node, augmentation: any}
    defstruct value: nil, left: :leaf, right: :leaf, augmentation: nil
  end

  @doc """
  Implements the identity processor
  """
  @spec identity(Node.bst_node) :: Node.bst_node
  def identity(bst_node), do: bst_node


  @doc """
  Creates a new Binary Search Tree with the root's value as the given 'value'.
  """
  @spec new(any, [{atom(), (Node.bst_node -> Node.bst_node)}]) :: Node.bst_node

  def new(value, processors \\ []) do
    processors = Keyword.merge([pre: &identity/1, post: &identity/1], processors)
    %Node{value: value, left: :leaf, right: :leaf} |> processors[:post].()
  end

  @doc """
  Creates and inserts a node with its value as 'node_value' into the tree.
  """
  @spec insert(Node.bst_node | :leaf, any, [{atom(), (Node.bst_node -> Node.bst_node)}]) :: Node.bst_node

  def insert(bst_node, node_value, processors \\ [])
  def insert(:leaf, node_value, processors), do: new(node_value, processors)
  def insert(%Node{value: value, left: left, right: right} = current_node, node_value, processors) do
    processors = Keyword.merge([pre: &identity/1, post: &identity/1], processors)
    if node_value < value do
      current_node
        |> processors[:pre].()
        |> (fn bst_node -> %{bst_node | left: insert(left, node_value, processors)} end).()
        |> processors[:post].()
    else
      current_node
        |> processors[:pre].()
        |> (fn bst_node -> %{bst_node | right: insert(right, node_value, processors)} end).()
        |> processors[:post].()
    end
  end

  @doc """
  Removes a node with 'node_value' from the given 'tree'. Returns :leaf if the
  node does not exist.
  """
  @spec delete_node(Node.bst_node, any) :: Node.bst_node | nil

  def delete_node(tree, node_value) do
    if exists?(tree, node_value) do
      delete tree, node_value
    else
      nil
    end
  end

  defp delete(tree, node_value) do
    cond do
      tree.value == node_value -> del(tree)
      tree.value <  node_value ->
        %Node{tree | right: delete(tree.right, node_value)}
      tree.value > node_value ->
        %Node{tree | left: delete(tree.left,node_value)}
    end
  end

  defp del(%Node{left: :leaf,  value: _, right: right}), do: right
  defp del(%Node{left: left, value: _, right: :leaf}),   do: left
  defp del(%Node{left: _, value: _, right: right} = current_node) do
    %{current_node | value: min(right), right: delete(right, min(right))}
  end

  defp min(%Node{left: :leaf,  value: val, right: _}), do: val
  defp min(%Node{left: left, value: _,   right: _}), do: min left


  @doc """
  Finds the node with the provided 'node_value' or nil if it does not
  exist in the tree.
  """
  @spec find_node(Node.bst_node | :leaf, any) :: Node.bst_node | nil

  def find_node(:leaf, _), do: nil
  def find_node(bst_node = %{value: node_value, left: _, right: _},
    node_value) do
    bst_node
  end

  def find_node(bst_node, node_value) do
    if node_value < bst_node.value do
      find_node bst_node.left, node_value
    else
      find_node bst_node.right, node_value
    end
  end

  @doc """
  Finds the parent of the node with the given 'node_value'.
  """
  @spec find_parent(Node.bst_node | :leaf, any) :: Node.bst_node | nil

  def find_parent(:leaf, _), do: nil
  def find_parent(bst_node, node_value) do
    _ = if bst_node.left != :leaf && bst_node.left.value == node_value do
      bst_node
    end
    if bst_node.right != :leaf && bst_node.right.value == node_value do
      bst_node
    else
      if node_value < bst_node.value do
        find_parent bst_node.left, node_value
      else
        find_parent bst_node.right, node_value
      end
    end
  end

  @doc """
  Finds the depth of the node with the given 'node_value'.
  """
  @spec node_depth(Node.bst_node | nil, any) :: integer

  def node_depth(tree, node_value), do: nd tree, node_value, 0

  defp nd(:leaf, _, _), do: -1
  defp nd(%{value: node_value, left: _, right: _},
    node_value, depth), do: depth
  defp nd(tree_node, node_value, depth) do
    if node_value < tree_node.value do
      nd tree_node.left, node_value, depth + 1
    else
      nd tree_node.right, node_value, depth + 1
    end
  end

  @doc """
  Finds the height of the given 'tree'.
  """
  @spec tree_height(Node.bst_node) :: integer

  def tree_height(tree) do
    tree
    |> th(0)
    |> Enum.group_by(fn {_, h} -> h end)
    |> Map.to_list
    |> List.last
    |> Tuple.to_list
    |> List.first
  end

  defp th(:leaf, _), do: []
  defp th(%{value: val, left: :leaf, right: :leaf}, h), do: [{val, h}]
  defp th(tree_node, h) do
    [{tree_node.value, h}] ++ th(tree_node.left, h + 1) ++ th(tree_node.right, h + 1)
  end

  @doc """
  Does a Depth-First Search in the given 'tree'. The nodes' values are
  returned in a list. The order of the search is passed into 'order' using
  the atoms ':in_order', ':pre_order' or ':post_order'
  """
  @spec depth_first_search(BST.bst_node, atom) :: list(any)

  def depth_first_search(tree, order) when order == :pre_order or
    order == :in_order  or
    order == :post_order do
    dfs tree, order
  end

  defp dfs(:leaf, _), do: []
  defp dfs(%{value: val, left: :leaf, right: :leaf}, _), do: [val]
  defp dfs(tree_node, order) do
    case order do
      :pre_order  ->
        [tree_node.value]          ++ dfs(tree_node.left, order)  ++ dfs(tree_node.right, order)
      :in_order   ->
        dfs(tree_node.left, order) ++ [tree_node.value]           ++ dfs(tree_node.right, order)
      :post_order ->
        dfs(tree_node.left, order) ++ dfs(tree_node.right, order) ++ [tree_node.value]
    end
  end


  defp children(list) do
    list
      |> Enum.map(fn (x) -> case x do
            %{left: :leaf, value: _, right: :leaf} -> []
            %{left: left, value: _, right: :leaf} -> left
            %{left: :leaf, value: _, right: right} -> right
            %{left: left, value: _, right: right} -> [left, right]
            _ -> []
          end
        end)
      |> List.flatten
  end

  @doc """
  Performs a Breadth-First Search in the given 'tree'. The nodes' values are
  returned as a list.
  """
  @spec breadth_first_search(Node.bst_node) :: nonempty_list(any)

  def breadth_first_search(tree) do
    [tree]
      |> bfs()
      |> Enum.map(fn (x) -> x.value end)
  end

  defp bfs([]), do: []
  defp bfs(list) do
    list ++ bfs(children(list))
  end

  @doc """
  Returns true if a node with the given 'node_value' exists in the 'tree' or
  false otherwise.
  """
  @spec exists?(Node.bst_node, any) :: boolean

  def exists?(tree, node_value) do
    e tree, node_value
  end

  defp e(:leaf, _), do: false
  defp e(%Node{value: node_value, left: _, right: _}, node_value), do: true
  defp e(tree_node, node_value) do
    if node_value < tree_node.value do
      e tree_node.left, node_value
    else
      e tree_node.right, node_value
    end
  end

  @doc """
  Returns how many occurrences of the given 'node_value' are inside the
  'tree'.
  """
  @spec how_many?(Node.bst_node, any) :: pos_integer

  def how_many?(tree, node_value) do
    d tree, node_value, 0
  end

  defp d(:leaf, _, count), do: count
  defp d(tree_node, node_value, count) do
    if node_value < tree_node.value do
      d tree_node.left, node_value, count
    else
      if node_value == tree_node.value do
        d tree_node.right, node_value, count + 1
      else
        d tree_node.right, node_value, count
      end
    end
  end
end
