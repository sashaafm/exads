defmodule Queue do

	@moduledoc """
	An implmentation of the Queue data structure with lists.
	"""

	@doc """
	Returns a new empty queue.
	"""
	@spec new() :: []

	def new, do: []

	@doc """
	Inserts a new element into the queue and returns the resulting queue.
	"""
	@spec enqueue(list(any()), any()) :: list(any())

	def enqueue(queue, elem) do 
		queue ++ [elem]
	end

	@doc """
	Removes the first element from the queue returning a tuple {element, result}.
	"""
	@spec dequeue(list(any())) :: tuple()

	def dequeue([]), do: {nil, []}
	def dequeue([head | tail]) do 
		{head, tail}
	end

	@doc """
	Deletes the first element from the queue returning the resulting queue.
	"""
	@spec delete(list(any())) :: list(any())

	def delete([]), do: []
	def delete([head | tail]), do: tail

	@doc """
	Returns true if the queue is empty or false otherwise.
	"""
	@spec empty?(list(any())) :: boolean
	
	def empty?(queue), do: Enum.empty? queue

	@doc """
	Returns the first element in the queue.
	"""
	@spec first(list(any())) :: any() | nil

	def first([]), do: nil
	def first([head | tail]), do: head

	@doc """
	Returns the maximum element in the queue using Elixir's built-in hierarchy.
	"""
	@spec max(list(any())) :: any() | nil

	def max(queue), do: queue |> Enum.sort |> List.last

	@doc """
	Returns true if the elem is a member of the queue or false otherwise.
	"""
	@spec member?(list(any()), any()) :: boolean()

	def member?(queue, elem), do: Enum.member? queue, elem

	@doc """
	Returns the position in the queue of a given element. Returns -1 if the
	element is not present. If the element appears more than once, then the 
	first occurrence is considered.
	"""
	@spec position(list(any()), any()) :: integer

	def position(queue, elem) do 
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
	Given a queue and an element returns true if element appears more than
	once in the queue or false otherwise.
	"""
	@spec more_than_once(list(any()), any()) :: boolean

	def more_than_once(queue, elem), do: mto queue, elem

	defp mto([], _), do: false
	defp mto([head | tail], elem) do
		if head == elem do 
			if position(tail, elem) >= 1 do 
				true
			else
				false
			end
		else
			mto tail, elem
		end
	end

	@doc """
	Returns the size of the queue.
	"""
	@spec size(list(any())) :: pos_integer()

	def size(queue), do: length(queue)


end