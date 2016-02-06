defmodule StackTest do
  use ExUnit.Case, async: true
  alias Exads.DataStructures.Stack, as: S
  doctest Exads

  test "new stack" do
    assert S.new() == []
  end

  test "push to empty stack" do 
  	assert S.push([],  1) == [1]
  end

  test "push to non-empty stack" do 
  	assert S.push([1, 2, 3], 4) == [4, 1, 2, 3]
  end

  test "pop from empty stack" do 
  	assert S.pop([]) == nil
  end

  test "pop from non-empty stack" do 
  	assert S.pop([1, 2, 3]) == {1, [2, 3]}
  end

  test "pop from non-empty stack with one elem" do 
  	assert S.pop([1]) == {1, []}
  end

  test "delete from empty stack" do 
  	assert S.delete([]) == nil
  end

  test "delete from non-empty stack" do 
  	assert S.delete([7, 6, "hello", 9, << 10 :: 8 >>, 6]) == [6, "hello", 9, 
  		<< 10 :: 8 >>, 6]
  end

  test "delete from non-empty stack with one elem" do 
  	assert S.delete(["just this elem"]) == []
  end

  test "empty?" do 
  	assert S.empty?([]) == true
  end

  test "non-empty?" do 
  	assert S.empty?(["abc"]) == false
  end

  test "non-empty? with wrong type" do 
  	assert_raise Protocol.UndefinedError, fn -> S.empty?("hello") end
  end

  test "top with empty stack" do 
  	assert S.top([]) == nil
  end

  test "top with non-empty stack" do 
  	assert S.top(["a", "b", "c"]) == "a"
  end

  test "top with wrong type" do 
  	assert_raise FunctionClauseError, fn -> S.top({:a, :b}) end
  end

  test "max with empty stack" do 
  	assert S.max([]) == nil
  end

  test "max with non-empty stack" do 
  	assert S.max([1, 2, 3]) == 3
  end

  test "max with non-empty stack with one elem" do 
  	assert S.max([:a]) == :a
  end

  test "max with non-empty stack with duplicate elem" do 
  	assert S.max([:b, :a, :c, :a, :c, :b]) == :c
  end

  test "member? with empty stack" do 
  	assert S.member?([], 1) == false
  end

  test "member? with non-empty stack and member" do 
  	assert S.member?([3, 6, 2, 4], 6) == true
  end

  test "member? with non-empty stack and non-member" do 
  	assert S.member?([3, 6, 2, 4], 9) == false
  end

  test "position with empty stack" do 
  	assert S.position([], 6) == -1
  end

  test "position with non-empty stack and member elem" do
  	assert S.position([4, 5, 2], 5) == 2
  end

  test "position with non-empty stack and non-member elem" do 
  	assert S.position([4, 5, 2], 6) == -1
  end

  test "position with non-empty stack and duplicate elem" do 
  	assert S.position([4, 5, 2, 4], 4) == 1
  end

  test "more_than_once wih empty stack" do 
  	assert S.more_than_once([], 1) == false
  end

  test "more_than_once with non-empty stack and non-member" do 
  	assert S.more_than_once([1, 2, 3], 0) == false
  end

  test "more_than_once with non-empty stack and member" do 
  	assert S.more_than_once([1, 2, 3], 3) == false
  end  

  test "more_than_once with non-empty stack and duplicate member" do 
  	assert S.more_than_once([1, 2, 3, 2], 2) == true
  end  

end