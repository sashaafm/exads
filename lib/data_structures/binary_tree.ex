defmodule Exads.DataStructures.BinaryTree do

	@moduledoc """
	An implementation of the Binary Tree abstract data structure using Struct.
	"""

	defstruct value: nil, left: nil, right: nil
	
	def new(value) do 
		%__MODULE__{value: value, left: nil, right: nil}
	end

	def insert(tree, value, side) when side == :left or side == :right do 
		tree
		|> Map.put(side, %__MODULE__{value: value, left: nil, right: nil})
	end

	def find_node(%__MODULE__{value: val, left: l, right: r}, node_value) do 

	end
end