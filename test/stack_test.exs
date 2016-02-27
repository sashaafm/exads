defmodule StackTest do
  use ExUnit.Case, async: true
  alias Exads.DataStructures.Stack, as: S
  doctest Exads

  ExUnit.configure exclude: :pending

  test "new stack" do
    assert {S, 0, []} == S.new()
  end

  test "push to empty stack" do
    assert S.push(S.new,  1) == S.from_list([1])
  end

  test "from empty list" do
    assert S.from_list([]) == {S, 0, []}
  end

  test "from short list" do
    assert S.from_list([1,2]) == {S, 2, [1, 2]}
  end

  test "from long list" do
    the_list = 1..1_000_000 |> Enum.into([])
    assert S.from_list(the_list) == {S, 1_000_000, the_list}
  end

  test "push to non-empty stack" do
    stack = [1, 2, 3]    |> S.from_list
    exp   = [4, 1, 2, 3] |> S.from_list
    assert S.push(stack, 4) == exp
  end

  test "pop from empty stack" do
    assert S.pop(S.new) == nil
  end

  test "pop from non-empty stack" do
    stack = [1, 2, 3] |> S.from_list
    exp   = [2, 3]    |> S.from_list
    assert S.pop(stack) == {1, exp}
  end

  test "pop from non-empty stack with one elem" do
    stack = [1] |> S.from_list
    exp   = S.new
    assert S.pop(stack) == {1, exp}
  end

  test "delete from empty stack" do
    assert S.delete(S.new) == nil
  end

  test "delete from non-empty stack" do
    stack = [7, 6, "hello", 9, << 10 :: 8 >>, 6] |> S.from_list
    exp   = [6, "hello", 9, << 10 :: 8 >>, 6] |> S.from_list
    assert S.delete(stack) == exp
  end

  test "delete from non-empty stack with one elem" do
    stack = ["just this elem"] |> S.from_list
    assert S.delete(stack) == S.new
  end

  test "empty?" do
    assert S.empty?(S.new) == true
  end

  test "non-empty?" do
    assert S.empty?(S.from_list(["abc"])) == false
  end

  @tag :pending
  # I do think, "letting it crash" with an `ArgumentError` or a
  # `FunctionClauseError` were more Elixir style.
  test "non-empty? with wrong type" do
    assert_raise Protocol.UndefinedError, fn -> S.empty?("hello") end
  end

  test "top with empty stack" do
    assert S.top(S.new) == nil
  end

  test "top with non-empty stack" do
    stack = ["a", "b", "c"] |> S.from_list
    assert S.top(stack) == "a"
  end

  test "top with wrong type" do
    assert_raise FunctionClauseError, fn -> S.top({:a, :b}) end
  end

  test "max with empty stack" do
    assert S.max(S.new) == nil
  end

  test "max with non-empty stack" do
    stack = [1,2,3] |> S.from_list
    assert S.max(stack) == 3
  end

  test "max with non-empty stack with one elem" do
    stack = [:a] |> S.from_list
    assert S.max(stack) == :a
  end

  test "max with non-empty stack with duplicate elem" do
    stack = [:b, :a, :c, :a, :c, :b] |> S.from_list
    assert S.max(stack) == :c
  end

  test "min with empty stack" do
    assert S.min(S.new) == nil
  end

  test "min with non-empty stack" do
    stack = [1,2,3] |> S.from_list
    assert S.min(stack) == 1
  end

  test "min with non-empty stack with one elem" do
    stack = [:a] |> S.from_list
    assert S.min(stack) == :a
  end

  test "min with non-empty stack with duplicate elem" do
    stack = [:b, :a, :c, :a, :c, :b] |> S.from_list
    assert S.min(stack) == :a
  end

  test "member? with empty stack" do
    assert S.member?(S.new, 1) == false
  end

  test "member? with non-empty stack and member" do
    stack = [3, 6, 2, 4] |> S.from_list
    assert S.member?(stack, 6) == true
  end

  test "member? with non-empty stack and non-member" do
    stack = [3, 6, 2, 4] |> S.from_list
    assert S.member?(stack, 9) == false
  end

  test "position with empty stack" do
    assert S.position(S.new, 6) == nil
  end

  test "position with non-empty stack and member elem" do
    stack = [4, 5, 2] |> S.from_list
    assert S.position(stack, 5) == 1
  end

  test "position with non-empty stack and non-member elem" do
    stack = [4, 5, 2] |> S.from_list
    assert S.position(stack, 6) == nil
  end

  test "position with non-empty stack and duplicate elem" do
    stack = [4, 5, 2, 4] |> S.from_list
    assert S.position(stack, 4) == 0
  end

  test "more_than_once wih empty stack" do
    assert S.more_than_once(S.new, 1) == false
  end

  test "more_than_once with non-empty stack and non-member" do
    stack = [1, 2, 3] |> S.from_list
    assert S.more_than_once(stack, 0) == false
  end

  test "more_than_once with non-empty stack and member" do
    stack = [1, 2, 3] |> S.from_list
    assert S.more_than_once(stack, 3) == false
  end

  test "more_than_once with non-empty stack and duplicate member" do
    stack = [1, 2, 3, 2] |> S.from_list
    assert S.more_than_once(stack, 2) == true
  end

  test "size of empty stack" do
    assert S.size(S.new) == 0
  end

  test "size of short stack" do
    stack = [1,2,3] |> S.from_list
    assert S.size(stack) == 3
  end

  test "size of long stack" do
    stack = 1..1_000_000 |> Enum.into([]) |> S.from_list
    assert S.size(stack) == 1_000_000
  end
end
