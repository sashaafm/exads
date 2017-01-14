defmodule Exads.DataStructures.AVLTreeTest do
  use ExUnit.Case, async: true

  alias Exads.DataStructures.BinarySearchTree, as: BST
  alias Exads.DataStructures.AVLTree, as: AVL

  setup do
    tree = AVL.new(6) |> AVL.insert(3) |> AVL.insert(12)
    {:ok, %{tree: tree}}
  end

  describe "new" do

    test "new" do
      assert AVL.new(0) ==
        %BST.Node{left:         :leaf,
                  right:        :leaf,
                  value:        0,
                  augmentation: %AVL.Augmentation{height: 0, bf: 0}}
    end
  end

  describe "insert" do

    test "right-heavy insert with no rotation required", %{tree: tree} do
      assert tree |> AVL.insert(14) ==
        %BST.Node{left:         %BST.Node{left:         :leaf,
                                          right:        :leaf,
                                          value:        3,
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
        assert tree |> AVL.insert(5) ==
          %BST.Node{left:         %BST.Node{left:         :leaf,
                                            right:        %BST.Node{left:         :leaf,
                                                                    right:        :leaf,
                                                                    value:        5,
                                                                    augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                            value:        3,
                                            augmentation: %AVL.Augmentation{height: 1, bf: -1}},
                    right:        %BST.Node{left:         :leaf,
                                            right:        :leaf,
                                            value:        12,
                                            augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                    value:  6,
                    augmentation: %AVL.Augmentation{height: 2, bf: 1}}
    end

    test "right-heavy insert with single rotation required", %{tree: tree} do
      assert tree |> AVL.insert(11) |> AVL.insert(14) |> AVL.insert(15) ==
        %BST.Node{left:         %BST.Node{left:         %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        3,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          right:        %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        11,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          value:        6,
                                          augmentation: %AVL.Augmentation{height: 1, bf: 0}},
                  right:        %BST.Node{left:         :leaf,
                                          right:        %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        15,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          value:        14,
                                          augmentation: %AVL.Augmentation{height: 1, bf: -1}},
                  value:  12,
                  augmentation: %AVL.Augmentation{height: 2, bf: 0}}

    end

    test "left-heavy insert with single rotation required", %{tree: tree} do
      assert tree |> AVL.insert(5) |> AVL.insert(2) |> AVL.insert(1) ==
        %BST.Node{left:         %BST.Node{left:         %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        1,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          right:        :leaf,
                                          value:        2,
                                          augmentation: %AVL.Augmentation{height: 1, bf: 1}},
                  right:        %BST.Node{left:         %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        5,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          right:        %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        12,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          value:        6,
                                          augmentation: %AVL.Augmentation{height: 1, bf: 0}},
                  value:  3,
                  augmentation: %AVL.Augmentation{height: 2, bf: 0}}

    end

    test "right-heavy insert with double rotation required", %{tree: tree} do
      assert tree |> AVL.insert(14) |> AVL.insert(11) |> AVL.insert(10) ==
        %BST.Node{left:         %BST.Node{left:         %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        3,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          right:        %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        10,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          value:        6,
                                          augmentation: %AVL.Augmentation{height: 1, bf: 0}},
                  right:        %BST.Node{left:         :leaf,
                                          right:        %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        14,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          value:        12,
                                          augmentation: %AVL.Augmentation{height: 1, bf: -1}},
                  value:  11,
                  augmentation: %AVL.Augmentation{height: 2, bf: 0}}

    end

    test "left-heavy insert with double rotation required", %{tree: tree} do
      assert tree |> AVL.insert(2) |> AVL.insert(4) |> AVL.insert(5) ==
        %BST.Node{left:         %BST.Node{left:         %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        2,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          right:        :leaf,
                                          value:        3,
                                          augmentation: %AVL.Augmentation{height: 1, bf: 1}},
                  right:        %BST.Node{left:         %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        5,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          right:        %BST.Node{left:         :leaf,
                                                                  right:        :leaf,
                                                                  value:        12,
                                                                  augmentation: %AVL.Augmentation{height: 0, bf: 0}},
                                          value:        6,
                                          augmentation: %AVL.Augmentation{height: 1, bf: 0}},
                  value:  4,
                  augmentation: %AVL.Augmentation{height: 2, bf: 0}}

    end
  end



end