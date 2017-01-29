defmodule BinarySearchTreeTest do
  use ExUnit.Case, async: true
  alias Exads.DataStructures.BinarySearchTree, as: BST
  doctest Exads

  defmodule ComplexTestValue do
    defstruct key: 0, value: ""
  end

  defimpl BST.Comparable, for: ComplexTestValue do
    import Kernel, except: [{:>, 2}, {:<, 2}]

    def left > right, do: Kernel.>(left.key, right.key)
    def left < right, do: Kernel.<(left.key, right.key)
  end

  setup do
    {:ok, tree: BST.new(2) |> BST.insert(1) |> BST.insert(3)}
  end

  test "new BST" do
    assert BST.new(2) == %BST.Node{left: :leaf, right: :leaf, value: 2}
  end

  test "insert value in BST rightside", tree do
    assert BST.insert(tree[:tree], 5) ==
      %BST.Node{left: %BST.Node{left: :leaf,
                right: :leaf,
                value: 1},
        right: %BST.Node{left: :leaf,
                 right: %BST.Node{left: :leaf,
                          right: :leaf,
                          value: 5 },
                 value: 3},
        value: 2}
  end

  test "insert value in BST leftside", tree do
    assert BST.insert(tree[:tree], 0) ==
      %BST.Node{left:  %BST.Node{left:  %BST.Node{left:  :leaf,
                          right: :leaf,
                          value: 0},
                 right: :leaf,
                 value: 1},
        right: %BST.Node{left:  :leaf,
                 right: :leaf,
                 value: 3},
        value: 2}
  end

  test "insert complex value in BST" do
    assert BST.new(%ComplexTestValue{key: 6}) |> BST.insert(%ComplexTestValue{key: 1}) ==
      %BST.Node{left:   %BST.Node{left:    :leaf,
                                 right:   :leaf,
                                 value:   %ComplexTestValue{key: 1}},
                right:  :leaf,
                value:  %ComplexTestValue{key: 6}}

  end

  test "delete existing node in BST rightside", tree do
    assert BST.delete_node(tree[:tree], 3) ==
      %BST.Node{left:  %BST.Node{left:  :leaf,
                right: :leaf,
                value: 1},
        right: :leaf,
        value: 2}
  end

  test "delete existing node in BST leftside", tree do
    assert BST.delete_node(tree[:tree], 1) ==
    %BST.Node{left:  :leaf,
      right: %BST.Node{left:  :leaf,
               right: :leaf,
               value: 3},
      value: 2}
  end

  test "delete existing node right side with left children" do
    tree = BST.new(6) |> BST.insert(1) |> BST.insert(12) |> BST.insert(8) |> BST.insert(9)
    assert BST.delete_node(tree, 12) ==
    %BST.Node{left:   %BST.Node{left:   :leaf,
                right:  :leaf,
                value:  1},
      right:  %BST.Node{left:   :leaf,
                right:  %BST.Node{left:   :leaf,
                          right:  :leaf,
                          value:  9},
                value:  8},
      value:  6}
  end

  test "delete non-existing node in BST", tree do
    assert BST.delete_node(tree[:tree], 8) == nil
  end

  test "find existing node", tree do
    assert BST.find_node(tree[:tree], 3) ==
      %BST.Node{left: :leaf, right: :leaf, value: 3}
  end

  test "find non-existing node", tree do
    assert BST.find_node(tree[:tree], 8) == nil
  end

  test "find existing node's parent", tree do
    assert BST.find_parent(tree[:tree], 3) ==
      %BST.Node{left:  %BST.Node{left:  :leaf,
                right: :leaf,
                value: 1},
        right: %BST.Node{left:  :leaf,
                right: :leaf,
                value: 3},
        value: 2}
  end

  test "find non-existing node's parent", tree do
    assert BST.find_parent(tree[:tree], 8) == nil
  end

  test "find existing node depth", tree do
    assert BST.node_depth (tree[:tree] |> BST.insert(4) |> BST.insert(5)), 5
      == 2
  end

  test "find non-existing node depth", tree do
    assert BST.node_depth tree[:tree], 9 == -1
  end

  test "find tree height", tree do
    assert BST.tree_height(tree[:tree]) == 1
    new_tree = tree[:tree] |> BST.insert(4) |> BST.insert(7)
                           |> BST.insert(8) |> BST.insert(6)
                           |> BST.insert(0) |> BST.insert(5) |> BST.insert(7)
    assert BST.tree_height(new_tree) == 5
  end

  test "depth-first search", tree do
    assert BST.depth_first_search(tree[:tree], :pre_order)   == [2, 1, 3]
    assert BST.depth_first_search(tree[:tree], :in_order)    == [1, 2, 3]
    assert BST.depth_first_search(tree[:tree], :post_order)  == [1, 3, 2]

    new_tree = tree[:tree] |> BST.insert(4) |> BST.insert(7)
                           |> BST.insert(8) |> BST.insert(6)
                           |> BST.insert(0) |> BST.insert(5) |> BST.insert(7)
    assert BST.depth_first_search(new_tree, :pre_order)
      == [2, 1, 0, 3, 4, 7, 6, 5, 8, 7]
    assert BST.depth_first_search(new_tree, :in_order)
      == [0, 1, 2, 3, 4, 5, 6, 7, 7, 8]
    assert BST.depth_first_search(new_tree, :post_order)
      == [0, 1, 5, 6, 7, 8, 7, 4, 3, 2]
  end

  test "breadth-first search", tree do
    assert BST.breadth_first_search(tree[:tree]) == [2, 1, 3]
    new_tree = tree[:tree] |> BST.insert(4) |> BST.insert(7)
                           |> BST.insert(8) |> BST.insert(6)
                           |> BST.insert(0) |> BST.insert(5) |> BST.insert(7)

    assert BST.breadth_first_search(new_tree) == [2, 1, 3, 0, 4, 7, 6, 8, 5, 7]
  end

  test "bread-first search 2 levels", _ do
    tree = BST.new(5) |> BST.insert(3) |> BST.insert(7) |> BST.insert(1)
    assert BST.breadth_first_search(tree) == [5, 3, 7, 1]
  end

  test "exists existing element", tree do
    assert BST.exists?(tree[:tree], 3) == true
  end

  test "exists non-existing element", tree do
    assert BST.exists?(tree[:tree], 12) == false
  end

  test "how many", tree do
    new_tree = tree[:tree] |> BST.insert(4) |> BST.insert(7)
                           |> BST.insert(8) |> BST.insert(6)
                           |> BST.insert(0) |> BST.insert(5) |> BST.insert(7)

    assert BST.how_many?(new_tree, 8) == 1
    assert BST.how_many?(new_tree, 7) == 2
    assert BST.how_many?(new_tree, 9) == 0
  end
end
