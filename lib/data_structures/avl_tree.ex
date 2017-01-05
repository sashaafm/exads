defmodule Exads.DataStructures.AVLTree do

  alias Exads.DataStructures.BinarySearchTree, as: BST


  @moduledoc """
  An implementation of the AVL Tree abstract data structure
  """

  @doc """
  Creates a new AVL Tree with the root's value as the given 'value'.
  """
  @spec new(any) :: BST.Node.bst_node

  def new(value), do: BST.new(value)


end