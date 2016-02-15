defmodule BinarySearchTreeTest do
  use ExUnit.Case, async: true
  alias Exads.DataStructures.BinarySearchTree, as: BST
  doctest Exads	

  setup do
    {:ok, tree: BST.new(2) |> BST.insert(1) |> BST.insert(3)}
  end

  test "new BST" do 
    assert BST.new(2) == %{left: :leaf, right: :leaf, value: 2}
  end

  test "insert value in BST rightside", tree do 
    assert BST.insert(tree[:tree], 5) == 
      %{left: %{left: :leaf, 
                right: :leaf, 
                value: 1},
        right: %{left: :leaf, 
                right: %{left: :leaf, 
                         right: :leaf, 
                         value: 5 },
                value: 3},
        value: 2}
  end

  test "insert value in BST leftside", tree do 
    assert BST.insert(tree[:tree], 0) ==
      %{left:  %{left:  %{left:  :leaf,
                          right: :leaf,
                          value: 0},
                 right: :leaf,
                 value: 1},
        right: %{left:  :leaf, 
                 right: :leaf,
                 value: 3},
        value: 2}
  end
end