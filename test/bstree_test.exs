defmodule BSTreeTest do
  use ExUnit.Case, async: true
  alias Exads.DataStructures.BSTree, as: Bst
  doctest Exads

  setup do
    {:ok, tree: Bst.new()}
  end

  test "new tree", %{tree: tree} do
    assert tree == :leaf
  end

  test "insert root", %{tree: tree}  do
    assert tree |> Bst.insert(5) ==
      {:leaf, 5, :leaf}
  end

  test "empty? with empty tree" do
    assert Bst.empty?(:leaf) == true
  end

  test "empty? with non-empty tree", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.empty?() == false
  end

  test "contains? with empty tree" do
    assert Bst.contains?(:leaf, 5) == false
  end

  test "contains? should be true", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.contains?(3) == true
  end

  test "contains? should be false", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.contains?(4) == false
  end

  test "exists? should be true", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.exists?(3) == true
  end

  test "insert left", %{tree: tree}  do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1) ==
      {{{:leaf, 1, :leaf}, 3, :leaf}, 5, :leaf}
  end

  test "insert right", %{tree: tree}  do
    assert tree |> Bst.insert(5) |> Bst.insert(7) |> Bst.insert(6) ==
      {:leaf, 5, {{:leaf, 6, :leaf}, 7, :leaf}}
  end

  test "delete leaf", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.delete(3) ==
      {:leaf, 5, :leaf}
  end

  test "delete root with left child", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.delete(5) ==
      {:leaf, 3, :leaf}
  end

  test "delete non-root with left child", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.delete(3) ==
      {{:leaf, 1, :leaf}, 5, :leaf}
  end

  test "delete non-root with right child", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(4)
      |> Bst.delete(3) ==
      {{:leaf, 4, :leaf}, 5, :leaf}
  end

  test "delete non-root with both children", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(4)
      |> Bst.insert(2) |> Bst.delete(3) ==
      {{:leaf, 2, {:leaf, 4, :leaf}}, 5, :leaf}
  end

  test "inorder", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.insert(4) |> Bst.insert(7) |> Bst.insert(6) |> Bst.insert(8)
      |> Bst.inorder() == [1, 3, 4, 5, 6, 7, 8]
  end

  test "preorder", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.insert(4) |> Bst.insert(7) |> Bst.insert(6) |> Bst.insert(8)
      |> Bst.preorder() == [5, 3, 1, 4, 7, 6, 8]
  end

  test "postorder", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.insert(4) |> Bst.insert(7) |> Bst.insert(6) |> Bst.insert(8)
      |> Bst.postorder() == [1, 4, 3, 6, 8, 7, 5]
  end

  test "breadth first", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.insert(4) |> Bst.insert(7) |> Bst.insert(6) |> Bst.insert(8)
      |> Bst.breadth_first == [5, 3, 7, 1, 4, 6, 8]
  end

  test "will find node", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.insert(4) |> Bst.insert(7) |> Bst.insert(6) |> Bst.insert(8)
      |> Bst.find_node(6) == {:leaf, 6, :leaf}
  end

  test "will not find node", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.insert(4) |> Bst.insert(7) |> Bst.insert(6) |> Bst.insert(8)
      |> Bst.find_node(100) == nil
  end

  test "will find parent", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.insert(4) |> Bst.insert(7) |> Bst.insert(6) |> Bst.insert(8)
      |> Bst.find_parent(8) == {{:leaf, 6, :leaf}, 7, {:leaf, 8, :leaf}}
  end

  test "node depth", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.insert(4) |> Bst.insert(7) |> Bst.insert(6) |> Bst.insert(8)
      |> Bst.node_depth(8) == 2
  end

  test "tree height", %{tree: tree} do
    assert tree |> Bst.insert(5) |> Bst.insert(3) |> Bst.insert(1)
      |> Bst.insert(4) |> Bst.insert(7) |> Bst.insert(6) |> Bst.insert(8)
      |> Bst.tree_height() == 3
  end


end
