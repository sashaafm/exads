defmodule Exads.DataStructures.PriorityQueue do

	@moduledoc """
	An implementation of the Priority Queue data structure with list and 
	tuples. The priority is recommended to be set by integers, but may be set
	using any type (evaluation will be done using Erlang's order system).
	"""

	@doc """
	Returns a new empty queue.
	"""
	@spec new() :: []

	def new(), do: []

	@doc """
	Inserts the element into the queue by FIFO policy.
	"""
	@spec insert_with_priority(list(tuple()), tuple()) :: list(tuple())

	def insert_with_priority(queue, {_item, _prio} = elem) do 
		queue ++ [elem]
	end

	@doc """
	Returns the element that is next up on the queue by priority. If two or more
	elements have the same priority, then the FIFO policy is used.
	"""
	@spec get_frontmost_element(list(tuple())) :: {tuple(), list(tuple())}

	def get_frontmost_element(queue) do 
		gfe queue
	end

	@doc """
	Removes the element from the queue without returning it.
	"""
	@spec delete(list(tuple())) :: list(tuple())

	def delete([]), do: []
	def delete([head | tail]), do: tail

	@doc """
	Returns true if the list is empty or false otherwise.
	"""
	@spec empty?(list(tuple())) :: boolean()

	def empty?(queue), do: Enum.empty? queue

	@doc """
	Returns the element that is next up without removing it.
	"""
	@spec front(list(tuple())) :: tuple() | nil

	def front([]), do: nil
	def front(queue) do 
		{result, _} = gfe queue
		result
	end

	defp gfe([]), do: nil
	defp gfe(queue) do 
		{_, front_elem} = queue
											|> Enum.group_by(fn {_, prio} -> prio end)
											|> Map.to_list
											|> List.last

		{List.last(front_elem), queue -- [List.last(front_elem)]}
	end

	@doc """
	Returns the if the given 'elem' is a member of the given 'queue' or false
	otherwise.
	"""
	@spec member?(list(tuple()), tuple()) :: boolean()
	
	def member?(queue, elem), do: Enum.member? queue, elem

	@doc """
	Returns the position by FIFO policy of the given 'elem' in the given 'queue'.
	"""
	@spec position_by_order(list(tuple()), tuple()) :: integer()

	def position_by_order(queue, elem) do 
		get_pos queue, elem, 1
	end

	defp get_pos([], _, _), do: -1
	defp get_pos([head | tail], elem, count) do 
		if head == elem do 
			count
		else
			get_pos tail, elem, count + 1
		end
	end	

	@doc """
	Returns the position by priority policy of the given 'elem' in the given
	'queue'. If there are duplicate elements, then the position is determined
	by FIFO policy.
	"""
	@spec position_by_priority(list(tuple()), tuple()) :: integer()

	def position_by_priority([]), do: -1
	def position_by_priority(queue, elem) do 
		find_elem_by_priority queue, elem, 1
	end

	defp find_elem_by_priority([], _, _), do: -1
	defp find_elem_by_priority([_head | tail] = queue, elem, count) do 
		if elem == front(queue) do 
			count
		else
			find_elem_by_priority tail, elem, count + 1
		end
	end

	@doc """
	Returns true if the given 'elem' appears in the 'queue' more than once or
	false otherwise.
	"""
	@spec more_than_once(list(tuple()), tuple()) :: boolean()

	def more_than_once(queue, elem), do: mto queue, elem

	defp mto([], _), do: false
	defp mto([head | tail], elem) do
		if head == elem do 
			if position_by_order(tail, elem) >= 1 do 
				true
			else
				false
			end
		else
			mto tail, elem
		end
	end

	@doc """
	Returns the size of the 'queue'.
	"""
	@spec size(list(tuple())) :: non_neg_integer()

	def size(queue), do: length queue

	@doc """
	Increases the priority of a given element in the queue, if the new priority
	is at least as large as the old one.
	"""
	@spec increase_element_priority(list(tuple()), tuple(), any()) :: list(tuple()) | []

	def increase_element_priority([], _, _), do: []
	def increase_element_priority(queue, {item, prio} = elem, new_prio) 
																										when new_prio >= prio do
		pos 			 = position_by_order queue, elem 
		first_half = (queue |> Enum.take(pos)) -- [elem]
		sec_half 	 = queue 	|> Enum.slice(pos, length(queue))

		first_half ++ [{item, new_prio}] ++ sec_half
	end
end