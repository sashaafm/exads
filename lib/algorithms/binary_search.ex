defmodule Exads.Algorithms.BinarySearch do
  use Bitwise

  @moduledoc """
  Implements the Binary Search algorithm.
  """

  @doc """
  Does a Binary Search onto the given 'list', returning the index of the given
  'key' if it exists or nil otherwise. The list must be sorted.
  """
  @spec binary_search([a], a) :: non_neg_integer | nil when a: var

  def binary_search(list, key) do
    bs list, key, 0, length(list)
  end

  defp bs([], _, _, _), do: nil
  defp bs([val], _, _, _), do: 0
  defp bs(_, _, min, max) when max < min, do: nil
  defp bs(list, key, min, max) do
    mid      = div min + max, 2
    val      = :array.get(:array.from_list(list), mid)
    #{_, val} = Enum.fetch list, mid
    #val = (min + max) >>> 1

    cond do
      val > key -> bs list, key, min, mid - 1
      val < key -> bs list, key, min + 1, max
      true      -> mid
    end
  end

end
