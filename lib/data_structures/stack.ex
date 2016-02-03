defmodule Exads.DataStructures.Stackex do

	@moduledoc """
	An implementation of the Stack data structure with lists.
	"""

	def new, do: []

	def push(stack, elem) do 
		(Enum.reverse(stack) ++ [elem]) |> Enum.reverse
	end

	def pop([]), do: nil
	def pop([head | tail] = _stack) do
		{head, tail}
	end

	def delete([]), do: nil
	def delete(stack) do 
		{_, result} = pop(stack)
		result
	end

	def empty?(stack) do 
		Enum.empty? stack
	end

	def top([]), do: nil
	def top(stack) do 
		stack |> List.first 
	end

	def max(stack) do
		stack |> Enum.sort |> List.last
	end

	def member?(stack, elem) do 
		Enum.member? stack, elem
	end

	def position(stack, elem) do 
		get_pos stack, elem, 1
	end

	defp get_pos([], _, _), do: -1
	defp get_pos([head | tail], elem, count) do 
		if head == elem do 
			count
		else
			get_pos tail, elem, count + 1
		end
	end

	def more_than_once(stack, elem), do: mto stack, elem

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

end
