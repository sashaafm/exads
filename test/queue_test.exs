defmodule QueueTest do
  use ExUnit.Case, async: true
  alias Exads.DataStructures.Queue, as: Q
  doctest Exads	

  test "new queue" do
    assert Q.new() == []
  end

  test "enqueue to empty queue" do 
  	assert Q.enqueue([],  1) == [1]
  end

  test "enqueue to non-empty queue" do 
  	assert Q.enqueue([1, 2, 3], 4) == [1, 2, 3, 4]
  end

  test "dequeue from empty queue" do 
  	assert Q.dequeue([]) == {nil, []}
  end

  test "dequeue from non-empty queue" do 
  	assert Q.dequeue([1, 2, 3]) == {1, [2, 3]}
  end

  test "dequeue from non-empty queue with one elem" do 
  	assert Q.dequeue([1]) == {1, []}
  end

  test "delete from empty queue" do 
  	assert Q.delete([]) == []
  end

  test "delete from non-empty queue" do 
  	assert Q.delete([7, 6, "hello", 9, << 10 :: 8 >>, 6]) == [6, "hello", 9, 
  		<< 10 :: 8 >>, 6]
  end

  test "delete from non-empty queue with one elem" do 
  	assert Q.delete(["just this elem"]) == []
  end

  test "empty?" do 
  	assert Q.empty?([]) == true
  end

  test "non-empty?" do 
  	assert Q.empty?(["abc"]) == false
  end

  test "non-empty? with wrong type" do 
  	assert_raise Protocol.UndefinedError, fn -> Q.empty?("hello") end
  end

  test "first with empty queue" do 
  	assert Q.first([]) == nil
  end

  test "first with non-empty queue" do 
  	assert Q.first(["a", "b", "c"]) == "a"
  end

  test "first with wrong type" do 
  	assert_raise FunctionClauseError, fn -> Q.first({:a, :b}) end
  end

  test "max with empty queue" do 
  	assert Q.max([]) == nil
  end

  test "max with non-empty queue" do 
  	assert Q.max([1, 2, 3]) == 3
  end

  test "max with non-empty queue with one elem" do 
  	assert Q.max([:a]) == :a
  end

  test "max with non-empty queue with duplicate elem" do 
  	assert Q.max([:b, :a, :c, :a, :c, :b]) == :c
  end

  test "member? with empty queue" do 
  	assert Q.member?([], 1) == false
  end

  test "member? with non-empty queue and member" do 
  	assert Q.member?([3, 6, 2, 4], 6) == true
  end

  test "member? with non-empty queue and non-member" do 
  	assert Q.member?([3, 6, 2, 4], 9) == false
  end

  test "position with empty queue" do 
  	assert Q.position([], 6) == -1
  end

  test "position with non-empty queue and member elem" do
  	assert Q.position([4, 5, 2], 5) == 2
  end

  test "position with non-empty queue and non-member elem" do 
  	assert Q.position([4, 5, 2], 6) == -1
  end

  test "position with non-empty queue and duplicate elem" do 
  	assert Q.position([4, 5, 2, 4], 4) == 1
  end

  test "more_than_once wih empty queue" do 
  	assert Q.more_than_once([], 1) == false
  end

  test "more_than_once with non-empty queue and non-member" do 
  	assert Q.more_than_once([1, 2, 3], 0) == false
  end

  test "more_than_once with non-empty queue and member" do 
  	assert Q.more_than_once([1, 2, 3], 3) == false
  end  

  test "more_than_once with non-empty queue and duplicate member" do 
  	assert Q.more_than_once([1, 2, 3, 2], 2) == true
  end    
	
end