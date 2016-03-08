defmodule Exads.DataStructures.BinarySearchTree do

	@moduledoc """
	An implementation of the Binary Search Tree abstract data structure 
	using Map.
	"""
	
	@doc """
	Creates a new Binary Search Tree with the root's value as the given 'value'.
	"""
	@spec new(any) :: %{}

	def new(value) do 
		%{value: value, left: :leaf, right: :leaf}
	end

	@doc """
	Creates and inserts a node with its value as 'node_value' into the tree.
	"""
	@spec insert(%{} | :leaf, any) :: %{}

	def insert(:leaf, node_value), do: new node_value
	def insert(%{value: value, left: left, right: right}, node_value) do 
		if node_value < value do 
			%{value: value, left: insert(left, node_value), right: right}
		else
			%{value: value, left: left, right: insert(right, node_value)}
		end
	end

	@doc """
	Removes a node with 'node_value' from the given 'tree'. Returns :leaf if the
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
				%{left: tree.left, 
										value: tree.value, 
										right: delete(tree.right, node_value)}
			tree.value > node_value ->
				%{left: delete(tree.left,node_value),
										value: tree.value, 
										right: tree.right}
		end
	end

	defp del(%{left: :leaf,  value: _, right: right}), do: right
	defp del(%{left: left, value: _, right: :leaf}),   do: left
	defp del(%{left: left, value: _, right: right}) do 
		%{left: left, value: min(right), right: delete(right, min(right))}
	end

	defp min(%{left: :leaf,  value: val, right: _}), do: val
	defp min(%{left: left, value: _,   right: _}), do: min left


	@doc """
	Finds the node with the provided 'node_value' or nil if it does not 
	exist in the tree.
	"""
	@spec find_node(%{} | :leaf, any) :: %{} | nil

	def find_node(:leaf, _), do: nil
	def find_node(node = %{value: node_value, left: _, right: _}, 
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

	@doc """
	Finds the parent of the node with the given 'node_value'.
	"""
	@spec find_parent(%{} | :leaf, any) :: %{} | nil

	def find_parent(:leaf, _), do: nil
	def find_parent(node, node_value) do 
		if node.left != :leaf && node.left.value == node_value do 
			node
		end
		if node.right != :leaf && node.right.value == node_value do 
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

	defp nd(:leaf, _, _), do: -1
	defp nd(%{value: node_value, left: _, right: _}, 
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

	defp th(:leaf, _), do: []
	defp th(%{value: val, left: :leaf, right: :leaf}, h), do: [{val, h}]
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

	defp dfs(:leaf, _), do: []
	defp dfs(%{value: val, left: :leaf, right: :leaf}, _), do: [val]
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

	defp bfs(%{value: val, left: :leaf, right: :leaf}) do 
		[val]
	end

	defp bfs(%{value: val, left: :leaf, right: right}) do 
		[val] ++ bfs(right)
	end

	defp bfs(%{value: val, left: left, right: :leaf}) do 
		[val] ++ bfs(left)
	end

	defp bfs(%{value: val, left: left, right: right}) do 
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

	defp e(:leaf, _), do: false
	defp e(%{value: node_value, left: _, right: _}, node_value), do: true
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

	defp d(:leaf, _, count), do: count
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