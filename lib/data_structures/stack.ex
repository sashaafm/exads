defmodule Exads.DataStructures.Stack do
  @moduledoc """
  An implementation of the Stack data structure with lists.
  """

  defstruct size: 0, stack: []

  @opaque t(a) :: %__MODULE__{size: non_neg_integer, stack: list(a)}
  @opaque t :: t(any)

  @doc """
  Returns a new empty stack.
  """
  @spec new() :: t

  def new, do: %__MODULE__{}

  @doc """
  Returns a stack created from a given list. It does assume, that the item at
  the front of the list is the youngest.
  """

  @spec from_list(list(a)) :: t(a) when a: var

  def from_list(list), do: %__MODULE__{size: length(list), stack: list}

  @doc """
  Return the stack with the given element pushed into it.
  """
  @spec push(t(a), a) :: t(a) when a: var

  def push(stack = %__MODULE__{size: s, stack: list}, e) do
    %{stack | size: s + 1, stack: [e|list]}
  end

  @doc """
  Pops the top element from the stack returning a tuple with the format
  {element, new_list}
  """
  @spec pop(t(a)) :: {a, t(a)} | nil when a: var

  def pop(%__MODULE__{size: 0, stack: []}), do: nil
  def pop(stack = %__MODULE__{size: s, stack: [head | tail]}) do
    {head, %{stack | size: s - 1, stack: tail}}
  end

  @doc """
  Deletes the top element from the stack.
  """
  @spec delete(t(a)) :: t(a) | nil when a: var

  def delete(stack = %__MODULE__{}) do
    case pop(stack) do
      {_, result} -> result
      nil         -> nil
    end
  end

  @doc """
  Returns true if the stack is empty or false otherwise.
  """
  @spec empty?(t) :: boolean

  def empty?(%__MODULE__{size: 0, stack: []}), do: true
  def empty?(%__MODULE__{}), do: false

  @doc """
  Returns the top element from the stack without removing it. If the stack
  is empty returns nil.
  """
  @spec top(t(a)) :: a | nil when a: var

  def top(stack = %__MODULE__{}) do
    case pop(stack) do
      {result, _} -> result
      nil         -> nil
    end
  end

  @doc """
  Returns the maximum element in the stack using Elixir's built-in hierarchy.
  """
  @spec max(t(a)) :: a | nil when a: var

  def max(%__MODULE__{stack: list}), do: minmax(list, &Enum.max/1)

  @doc """
  Returns the minimum element in the stack using Elixir's built-in hierarchy.
  """
  @spec min(t(a)) :: a | nil when a: var

  def min(%__MODULE__{stack: list}), do: minmax(list, &Enum.min/1)

  defp minmax([], _fun), do: nil
  defp minmax(list, fun), do: fun.(list)

  @doc """
  Given a stack and an element, returns true if the element is a member
  of the stack or false otherwise.
  """
  @spec member?(t(a), a) :: boolean when a: var

  def member?(%__MODULE__{stack: list}, e) do
    Enum.member? list, e
  end

  @doc """
  Returns the position in the stack of a given element. Returns -1 if the
  element is not present. If the element appears more than once, then the
  first occurrence is considered.
  """
  @spec position(t(a), a) :: non_neg_integer | nil when a: var

  def position(%__MODULE__{stack: list}, e) do
    list |> Enum.find_index(&(&1 === e))
  end

  @doc """
  Given a stack and an element returns true if element appears more than
  once in the stack or false otherwise.
  """
  @spec more_than_once(t(a), a) :: boolean when a: var

  def more_than_once({__MODULE__, _size, stack}, e), do: mto stack, e, 0

  defp mto([], _, _), do: false
  defp mto([e|_tail], e, 1), do: true
  defp mto([e|tail], e, 0), do: mto(tail, e, 1)
  defp mto([_head|tail], e, c), do: mto(tail, e, c)

  @doc """
  Returns the size of the stack.
  """
  @spec size(t) :: non_neg_integer()

  def size({__MODULE__, s, _stack}), do: s

end
