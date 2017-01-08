defmodule Exads.DataStructures.AVLTree do
  alias Exads.DataStructures.BinarySearchTree, as: BST


  defmodule Augmentation do

    @type augmentation :: %__MODULE__{height: integer, bf: integer}
    defstruct height: 0, bf: 0

  end


  @moduledoc """
  An implementation of the AVL Tree abstract data structure
  """

  @doc """
  Creates a new AVL Tree with the root's value as the given 'value'.
  """
  @spec new(any) :: BST.Node.bst_node

  def new(value), do: BST.new(value, [post: &post_processor/1])

  def insert(tree, node_value) do
    BST.insert(tree, node_value, [post: &post_processor/1])
  end

  def post_processor(node), do: augment(node) |> balance()


  @spec augment(BST.Node.bst_node | :leaf) :: BST.Node.bst_node
  defp augment(:leaf), do: :leaf
  defp augment(%BST.Node{left: :leaf, right: :leaf} = node), do: %{node | augmentation: %Augmentation{}}
  defp augment(%BST.Node{left: left, right: :leaf} = node) do
    %{node | augmentation: %Augmentation{height: left.augmentation.height + 1, bf: left.augmentation.height + 1}}
  end
  defp augment(%BST.Node{left: :leaf, right: right} = node) do
    %{node | augmentation: %Augmentation{height: right.augmentation.height + 1, bf: -1 * right.augmentation.height - 1}}
  end
  defp augment(%BST.Node{left: left, right: right} = node), do:
    %{node | augmentation: %Augmentation{height:  max(left.augmentation.height, right.augmentation.height) + 1,
                                         bf:      left.augmentation.height - right.augmentation.height}}

  defp balance(node) do
    if Kernel.abs(node.augmentation.bf) > 1 do
      rotate(node)
    else
      node |> augment()
    end
  end

  defp rotate(tree) do
    if (tree.augmentation.bf < -1) do
      left_rotation(tree)
    end
  end

  defp left_rotation(tree) do
    left = %BST.Node{left: tree.left, right: tree.right.left, value: tree.value} |> augment()
    right = %BST.Node{left: tree.right.right.left, right: tree.right.right.right, value: tree.right.right.value} |> augment()
    %BST.Node{left: left, right: right, value: tree.right.value} |> augment()
  end

  defp calculate_bf(%BST.Node{left: :leaf, right: :leaf}), do: 0
  defp calculate_bf(%BST.Node{left: :leaf, right: right}), do: Kernel.abs(right.augmentation.bf)
  defp calculate_bf(%BST.Node{left: left, right: :leaf}), do: left.augmentation.bf
  defp calculate_bf(%BST.Node{left: left, right: right}), do: Kernel.abs(left.augmentation.bf - right.augmentation.bf)

end