defmodule BinarySearchTest do
  use ExUnit.Case, async: true
  alias Exads.Algorithms.BinarySearch, as: BS
  doctest Exads

  test "empty list" do
    assert BS.binary_search([], 4) == nil
  end

  test "one elem list" do
    assert BS.binary_search([4], 4) == 0
  end

  test "two elem list" do
    assert BS.binary_search([1, 2], 2) == 1
    assert BS.binary_search([1, 2], 1) == 0
  end

  test "short list" do
    assert BS.binary_search([4, 5, 8, 9, 18, 29, 57, 79], 29) == 5
    assert BS.binary_search([4, 5, 8, 9, 18, 29, 57, 79], 79) == 7
    assert BS.binary_search([4, 5, 8, 9, 18, 29, 57, 79], 4)  == 0
    assert BS.binary_search([4, 5, 8, 9, 18, 29, 57, 79], 9)  == 3
  end

  test "medium list" do
    assert BS.binary_search((1..10_000) |> Enum.into([]), 1)      == 0
    assert BS.binary_search((1..10_000) |> Enum.into([]), 10_000) == 9999
    assert BS.binary_search((1..10_000) |> Enum.into([]), 5000)   == 4999
  end

  test "long list" do
    spawn fn ->
      assert BS.binary_search((1..1_000_000) |> Enum.into([]), 1)
        == 0
    end
    spawn fn ->
      assert BS.binary_search((1..1_000_000) |> Enum.into([]), 10_000)
        == 9999
    end
    spawn fn ->
      assert BS.binary_search((1..1_000_000) |> Enum.into([]), 1_000_000)
        == 999999
    end
  end

end
