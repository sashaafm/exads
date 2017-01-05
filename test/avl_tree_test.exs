defmodule Exads.DataStructures.AVLTreeTest do
  use ExUnit.Case, async: true

  alias Exads.DataStructures.BinarySearchTree, as: BST
  alias Exads.DataStructures.AVLTree, as: AVL

  test "new" do
    assert AVL.new(0) ==
      %BST.Node{left:   :leaf,
                right:  :leaf,
                value:  0}
  end



end