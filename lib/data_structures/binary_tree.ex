defmodule BinarySearchTree do

	@moduledoc """
	An implementation of the Binary Search Tree abstract data structure 
	using Struct.
	"""

	defstruct value: nil, left: nil, right: nil
	
	@doc """
	Creates a new Binary Search Tree with the root's value as the given 'value'.
	"""
	@spec new(any) :: %{}

	def new(value) do 
		%__MODULE__{value: value, left: nil, right: nil}
	end

	@doc """
	Creates and inserts a node with its value as 'node_value' into the tree.
	"""
	@spec insert(%{} | nil, any) :: %{}

	def insert(nil, node_value), do: new node_value
	def insert(%__MODULE__{value: value, left: left, right: right}, node_value) do 
		if node_value < value do 
			%__MODULE__{value: value, left: insert(left, node_value), right: right}
		else
			%__MODULE__{value: value, left: left, right: insert(right, node_value)}
		end
	end

	@doc """
	Removes a node with 'node_value' from the given 'tree'. Returns nil if the
	node does not exist.
	"""
	@spec delete_node(%{}, any) :: %{} | nil

	def delete_node(tree, node_value) do 
		if exists?(tree, node_value) do 
			delete tree, node_value
		else
			nil
		end
	end

	defp delete(tree, node_value) do
		cond do 
			tree.value == node_value -> del(tree)
			tree.value <  node_value -> 
				%__MODULE__{left: tree.left, 
										value: tree.value, 
										right: delete(tree.right, node_value)}
			tree.value > node_value ->
				%__MODULE__{left: delete(tree.left,node_value),
										value: tree.value, 
										right: tree.right}
		end
	end

	defp del(%__MODULE__{left: nil,  value: _, right: right}), do: right
	defp del(%__MODULE__{left: left, value: _, right: nil}),   do: left
	defp del(%__MODULE__{left: left, value: _, right: right}) do 
		%__MODULE__{left: left, value: min(right), right: delete(right, min(right))}
	end

	defp min(%__MODULE__{left: nil,  value: val, right: _}), do: val
	defp min(%__MODULE__{left: left, value: _,   right: _}), do: min left


	@doc """
	Finds the node with the provided 'node_value' or nil if it does not 
	exist in the tree.
	"""
	@spec find_node(%{}, any) :: %{} | nil

	def find_node(nil, _), do: nil
	def find_node(node = %__MODULE__{value: node_value, left: _, right: _}, 
																	 node_value) do 
		node
	end

	def find_node(node, node_value) do 
		if node_value < node.value do 
			find_node node.left, node_value
		else
			find_node node.right, node_value
		end
	end

	def find_parent(nil, _), do: nil
	def find_parent(node, node_value) do 
		if node.left != nil && node.left.value == node_value do 
			node
		end
		if node.right != nil && node.right.value == node_value do 
			node
		else
			if node_value < node.value do 
				find_parent node.left, node_value
			else
				find_parent node.right, node_value			
			end			
		end
	end

	@doc """
	Finds the depth of the node with the given 'node_value'.
	"""
	@spec node_depth(%{} | nil, any) :: integer

	def node_depth(tree, node_value), do: nd tree, node_value, 0

	defp nd(nil, _, _), do: -1
	defp nd(%__MODULE__{value: node_value, left: _, right: _}, 
								 node_value, depth), do: depth
	defp nd(tree_node, node_value, depth) do
 		if node_value < tree_node.value do 
 			nd tree_node.left, node_value, depth + 1
 		else
 			nd tree_node.right, node_value, depth + 1
 		end
	end

	@doc """
	Finds the height of the given 'tree'.
	"""
	@spec tree_height(%{}) :: integer

	def tree_height(tree) do
		tree
		|> th(0)
		|> Enum.group_by(fn {_, h} -> h end) 
		|> Map.to_list 
		|> List.last 
		|> Tuple.to_list 
		|> List.first
	end

	defp th(nil, _), do: []
	defp th(%__MODULE__{value: val, left: nil, right: nil}, h), do: [{val, h}]
	defp th(tree_node, h) do
		[{tree_node.value, h}] ++ th(tree_node.left, h + 1) ++ th(tree_node.right, h + 1)
	end

	@doc """
	Does a Depth-First Search in the given 'tree'. The nodes' values are
	returned in a list. The order of the search is passed into 'order' using
	the atoms ':in_order', ':pre_order' or ':post_order'
	"""
	@spec depth_first_search(%{}, atom) :: list(any)

	def depth_first_search(tree, order) when order == :pre_order or 
																					 order == :in_order  or 
														 							 order == :post_order do 
		dfs tree, order
	end

	defp dfs(nil, _), do: []
	defp dfs(%__MODULE__{value: val, left: nil, right: nil}, _), do: [val]
	defp dfs(tree_node, order) do
		case order do
		  :pre_order 	->
			  [tree_node.value]   			 ++ dfs(tree_node.left, order)  ++ dfs(tree_node.right, order)
			:in_order   ->
				dfs(tree_node.left, order) ++ [tree_node.value]   				++ dfs(tree_node.right, order)
			:post_order ->
				dfs(tree_node.left, order) ++ dfs(tree_node.right, order) ++ [tree_node.value]
		end

	end

	@doc """
	Performs a Breadth-First Search in the given 'tree'. The nodes' values are
	returned as a list.
	"""
	@spec breadth_first_search(%{}) :: list(any)

	def breadth_first_search(tree) do 
		bfs(tree)
	end

	defp bfs(%__MODULE__{value: val, left: nil, right: nil}) do 
		[val]
	end

	defp bfs(%__MODULE__{value: val, left: nil, right: right}) do 
		[val] ++ bfs(right)
	end

	defp bfs(%__MODULE__{value: val, left: left, right: nil}) do 
		[val] ++ bfs(left)
	end

	defp bfs(%__MODULE__{value: val, left: left, right: right}) do 
		[val] ++ bfs(left) ++ bfs(right)
	end

	@doc """
	Returns true if a node with the given 'node_value' exists in the 'tree' or
	false otherwise.
	"""
	@spec exists?(%{}, any) :: boolean

	def exists?(tree, node_value) do
		e tree, node_value
	end

	defp e(nil, _), do: false
	defp e(%__MODULE__{value: node_value, left: _, right: _}, node_value), do: true
	defp e(tree_node, node_value) do
 		if node_value < tree_node.value do 
 			e tree_node.left, node_value
 		else
 			e tree_node.right, node_value
 		end
	end

	@doc """
	Returns how many occurrences of the given 'node_value' are inside the 
	'tree'.
	"""
	@spec how_many?(%{}, any) :: pos_integer

	def how_many?(tree, node_value) do
		d tree, node_value, 0
	end

	defp d(nil, _, count), do: count
	defp d(tree_node, node_value, count) do
 		if node_value < tree_node.value do 
 			d tree_node.left, node_value, count
 		else
 			if node_value == tree_node.value do 
 				d tree_node.right, node_value, count + 1
 			else
 				d tree_node.right, node_value, count
 			end
 		end
	end	
end