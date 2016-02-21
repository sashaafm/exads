defmodule Exads.DataStructures.Stack do
  @moduledoc """
  An implementation of the Stack data structure with lists.
  """

  @opaque t(a) :: {__MODULE__, non_neg_integer, list(a)}
  @opaque t :: t(any)

  @doc """
  Returns a new empty stack.
  """
  @spec new() :: t

  def new, do: {__MODULE__, 0, []}

  @doc """
  Returns a stack created from a given list. It does assume, that the item at
  the front of the list is the youngest.
  """

  @spec from_list(list(a)) :: t(a) when a: var

  def from_list(list), do: {__MODULE__, length(list), list}
  
  @doc """
  Return the stack with the given element pushed into it.
  """
  @spec push(list(any()), any()) :: list(any())

  def push(stack, elem) do
    [elem|stack]
  end

  @doc """
  Pops the top element from the stack returning a tuple with the format
  {element, new_list}
  """
  @spec pop(list(any())) :: tuple()

  def pop([]), do: nil
  def pop([head | tail] = _stack) do
    {head, tail}
  end

  @doc """
  Deletes the top element from the stack.
  """
  @spec delete(list(any())) :: list(any())

  def delete([]), do: nil
  def delete(stack) do 
    {_, result} = pop(stack)
    result
  end

  @doc """
  Returns true if the stack is empty or false otherwise.
  """
  @spec empty?([]) :: boolean

  def empty?(stack) do 
    Enum.empty? stack
  end

  @doc """
  Returns the top element from the stack without removing it. If the stack
  is empty returns nil.
  """
  @spec top(list(any())) :: any() | nil

  def top([]), do: nil
  def top(stack) do 
    stack |> List.first 
  end

  @doc """
  Returns the maximum element in the stack using Elixir's built-in hierarchy.
  """
  @spec max(t(a)) :: a | nil when a: var

  def max({__MODULE__, _size, []}), do: nil
  def max({__MODULE__, _size, stack}) do
    stack |> Enum.max
  end

  @doc """
  Returns the minimum element in the stack using Elixir's built-in hierarchy.
  """
  @spec min(t(a)) :: a | nil when a: var

  def min({__MODULE__, _size, []}), do: nil
  def min({__MODULE__, _size, stack}) do
    stack |> Enum.min
  end

  @doc """
  Given a stack and an element, returns true if the element is a member
  of the stack or false otherwise.
  """
  @spec member?(list(any()), any()) :: boolean

  def member?(stack, elem) do 
    Enum.member? stack, elem
  end

  @doc """
  Returns the position in the stack of a given element. Returns -1 if the
  element is not present. If the element appears more than once, then the 
  first occurrence is considered.
  """
  @spec position(list(any()), any()) :: integer

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

  @doc """
  Given a stack and an element returns true if element appears more than
  once in the stack or false otherwise.
  """
  @spec more_than_once(list(any()), any()) :: boolean

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

  @doc """
  Returns the size of the stack.
  """
  @spec size(list(any())) :: pos_integer()

  def size(stack), do: length(stack)

end
