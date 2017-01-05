defmodule Exads.DataStructures.AVLTreeTest do
  use ExUnit.Case, async: true

  alias Exads.DataStructures.BinarySearchTree, as: BST
  alias Exads.DataStructures.AVLTree, as: AVL

  setup do
    tree = AVL.new(6) |> AVL.insert(1) |> AVL.insert(12)
    {:ok, %{tree: tree}}
  end

  test "new" do
    assert AVL.new(0) ==
      %BST.Node{left:         :leaf,
                right:        :leaf,
                value:        0,
                augmentation: %AVL.Augmentation{height: 0, bf: 0}}
  end

  test "right-heavy insert with no rotation required", %{tree: tree} do
    assert tree |> AVL.insert(14) ==
      %BST.Node{left:         %BST.Node{left:         :leaf,
                                        right:        :leaf,
                                        value:        1,
                                        augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                right:        %BST.Node{left:         :leaf,
                                        right:        %BST.Node{left:         :leaf,
                                                                right:        :leaf,
                                                                value:        14,
                                                                augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                        value:        12,
                                        augmentation: %AVL.Augmentation{height: 1, bf: -1}},
                value:  6,
                augmentation: %AVL.Augmentation{height: 2, bf: -1}}
  end

  test "left-heavy insert with no rotation required", %{tree: tree} do
      assert tree |> AVL.insert(2) ==
        %BST.Node{left:         %BST.Node{left:         :leaf,
                                          right:        %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        2,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          value:        1,
                                          augmentation: %AVL.Augmentation{height: 1, bf: -1}},
                  right:        %BST.Node{left:         :leaf,
                                          right:        :leaf,
                                          value:        12,
                                          augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                  value:  6,
                  augmentation: %AVL.Augmentation{height: 2, bf: 1}}
    end



end