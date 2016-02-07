defmodule Exads.DataStructures.PriorityQueue do

	@moduledoc """
	An implementation of the Priority Queue data structure with list and 
	tuples.
	"""

	def new(), do: []

	def insert_with_priority(queue, {_item, prio} = elem) when is_integer(prio) do 
		queue ++ [elem]
	end

	def get_frontmost_element(queue) do 
		gfe queue, nil, []
	end

	def delete([]), do: []
	def delete([head | tail]), do: tail

	def empty?(queue), do: Enum.empty? queue

	def front([]), do: nil
	def front(queue) do 
		{result, _} = gfe queue, nil, []
		result
	end

	defp gfe([head | []], front, new_queue), do: {front, new_queue}
	defp gfe([{_h_item, h_prio} = head | tail], front, new_queue) do 
		{tail_head_item, tail_head_prio} = List.first tail

		if h_prio >= tail_head_prio do 
			gfe tail, head, {tail_head_item, tail_head_prio}
		else
			gfe tail, {tail_head_item, tail_head_prio}, new_queue
		end
	end
	
	def member?(queue, elem), do: Enum.member? queue, elem

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

	def position_by_priority([]), do: -1
	def position_by_priority(queue) do 
		{priority, elem_list} = queue
														|> Enum.group_by(fn {item, prio} -> prio end) 
	 													|> Map.to_list 
														|> List.last
		List.first(elem_list)
	end

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

	def size(queue), do: length queue

end