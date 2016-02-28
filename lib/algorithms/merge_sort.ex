defmodule Exads.Algorithms.MergeSort do

  def merge_sort(list) do 
    ms list
  end

  defp ms([]), do: []
  defp ms([a]), do: [a]
  defp ms(list) do 
    {first_half, sec_half} = Enum.split list, div(length(list), 2)
    merge(ms(first_half), ms(sec_half))
  end

  defp merge([], sec_half), do: sec_half
  defp merge(first_half, []), do: first_half
  defp merge([fh | ft], sec_half = [sh | _]) when fh <= sh do 
    [fh] ++ merge ft, sec_half
  end

  defp merge(first_half, [sh | st]) do 
    [sh] ++ merge first_half, st
  end

  def parallel_merge_sort(list) do 
    pms list
  end

  defp pms([]), do: []
  defp pms([a]), do: [a]
  defp pms(list) do 
    current = self()
    {first_half, sec_half} = Enum.split list, div(length(list), 2)
    IO.inspect child_1 = spawn_link(fn -> send current, {self(), merge_sort(first_half)} end)
    IO.inspect child_2 = spawn_link(fn -> send current, {self(), merge_sort(sec_half)} end)    

    receive do 
      {child_1, msg} -> IO.inspect msg
      {child_2, msg} -> IO.inspect msg
    end

    receive do 
      {child_1, msg} -> IO.inspect msg
      {child_2, msg} -> IO.inspect msg
    end    
  end
  
end