defmodule Exads.DataStructures.AVLTree do
  alias Exads.DataStructures.BinarySearchTree, as: BST


  defmodule Augmentation do

    @moduledoc """
    AVL augmentation struct for BST required to implement AVL Tree
    """

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

  @doc """
  Creates and inserts a node with its value as 'node_value' into the tree.
  """

  @spec insert(BST.Node.bst_node, any) :: BST.Node.bst_node
  def insert(tree, node_value) do
    BST.insert(tree, node_value, [post: &post_processor/1])
  end

  @spec post_processor(BST.Node.bst_node) :: BST.Node.bst_node
  defp post_processor(bst_node), do: bst_node |> augment() |> balance()


  @spec augment(BST.Node.bst_node | :leaf) :: BST.Node.bst_node
  defp augment(:leaf), do: :leaf
  defp augment(%BST.Node{left: :leaf, right: :leaf} = bst_node), do: %{bst_node | augmentation: %Augmentation{}}
  defp augment(%BST.Node{left: left, right: :leaf} = bst_node) do
    %{bst_node | augmentation: %Augmentation{height: left.augmentation.height + 1, bf: left.augmentation.height + 1}}
  end
  defp augment(%BST.Node{left: :leaf, right: right} = bst_node) do
    %{bst_node | augmentation: %Augmentation{height: right.augmentation.height + 1, bf: -1 * right.augmentation.height - 1}}
  end
  defp augment(%BST.Node{left: left, right: right} = bst_node), do:
    %{bst_node | augmentation: %Augmentation{height:  max(left.augmentation.height, right.augmentation.height) + 1,
                                             bf:      left.augmentation.height - right.augmentation.height}}


  @spec balance(BST.Node.bst_node) :: BST.Node.bst_node
  defp balance(bst_node) do
    if Kernel.abs(bst_node.augmentation.bf) > 1 do
      rotate(bst_node)
    else
      bst_node |> augment()
    end
  end

  @spec rotate(BST.Node.bst_node) :: BST.Node.bst_node
  defp rotate(tree) do
    cond do
      tree.augmentation.bf < -1 -> rotate_left_heavy(tree)
      tree.augmentation.bf > 1 -> rotate_right_heavy(tree)
      true -> tree |> augment()
    end
  end

  @spec rotate_left_heavy(BST.Node.bst_node) :: BST.Node.bst_node
  defp rotate_left_heavy(tree) do
    # Transform to case 1 in case double rotation is required
    tree =
      if tree.right.augmentation.bf > 0 do
        %{tree | right: right_rotation(tree.right)} |> augment()
      else
        tree
      end
    left_rotation(tree)
  end

  @spec rotate_right_heavy(BST.Node.bst_node) :: BST.Node.bst_node
  defp rotate_right_heavy(tree) do
    # Transform to case 1 in case double rotation is required
    tree =
      if tree.left.augmentation.bf < 0 do
        %{tree | left: left_rotation(tree.left)} |> augment()
      else
        tree
      end
    right_rotation(tree)
  end

  @spec left_rotation(BST.Node.bst_node) :: BST.Node.bst_node
  defp left_rotation(tree) do
    left = %BST.Node{left: tree.left, right: tree.right.left, value: tree.value} |> augment()
    right = %BST.Node{left: tree.right.right.left, right: tree.right.right.right, value: tree.right.right.value} |> augment()
    %BST.Node{left: left, right: right, value: tree.right.value} |> augment()
  end

  @spec right_rotation(BST.Node.bst_node) :: BST.Node.bst_node
  defp right_rotation(tree) do
    right = %BST.Node{left: tree.left.right, right: tree.right, value: tree.value} |> augment()
    left = %BST.Node{left: tree.left.left.left, right: tree.left.left.right, value: tree.left.left.value} |> augment()
    %BST.Node{left: left, right: right, value: tree.left.value} |> augment()
  end


end