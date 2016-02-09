defmodule PriorityQueueTest do
  use ExUnit.Case, async: true
  alias Exads.DataStructures.PriorityQueue, as: Q
  doctest Exads	

  test "new queue" do
    assert Q.new() == []
  end

  test "insert_with_priority to empty queue" do 
  	assert Q.insert_with_priority([],  {"hello", 1}) == [{"hello", 1}]
  end

  test "insert_with_priority to non-empty queue" do 
  	assert Q.insert_with_priority([{:a, 1}, {:b, 2}, {:c, 3}], {:d, 4}) 
      == [{:a, 1}, {:b, 2}, {:c, 3}, {:d, 4}]
  end

  test "get_frontmost_element from empty queue" do 
  	assert Q.get_frontmost_element([]) == nil
  end

  test "get_frontmost_element from non-empty queue" do 
  	assert Q.get_frontmost_element([{:a, 2}, {:b, 5}, {:c, 3}]) 
      == {{:b, 5}, [{:a, 2}, {:c, 3}]}
  end

  test "get_frontmost_element from non-empty queue with duplicate prio" do 
    assert Q.get_frontmost_element([{:a, 2}, {:d, 5}, {:b, 5}, {:c, 3}]) 
      == {{:d, 5}, [{:a, 2}, {:b, 5}, {:c, 3}]}
  end  

  test "get_frontmost_element from non-empty queue with one elem" do 
  	assert Q.get_frontmost_element([{:a, 5}]) == {{:a, 5}, []}
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

  test "front with empty queue" do 
  	assert Q.front([]) == nil
  end

  test "front with non-empty queue" do 
  	assert Q.front([{:a, 3}, {:b, 2}, {:b, 9}]) == {:b, 9}
  end

  test "front with non-empty queue and duplicate prio" do 
    assert Q.front([{:b, 9}, {:a, 3}, {:b, 2}, {:b, 9}]) == {:b, 9}
  end

  test "front with non-empty queue and triple prio" do 
    assert Q.front([{:b, 9}, {:a, 3}, {:b, 2}, {:b, 13}]) == {:b, 13}
  end  

  test "front without enumerable" do 
  	assert_raise Protocol.UndefinedError, fn -> Q.front(1337) end
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

  test "position_by_order with empty queue" do 
    assert Q.position_by_order([], {:a, 4}) == -1
  end

  test "position_by_order with non-empty queue and member elem" do 
    assert Q.position_by_order([{:a, 4}, {:b, 8}, {:c, 2}], {:b, 8}) == 2
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