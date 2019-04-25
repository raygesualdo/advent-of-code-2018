defmodule Quicksort do
  def sort([]), do: []
  def sort([head]), do: [head]

  def sort([pivot | tail]) do
    {left, right} = Enum.split_with(tail, &(&1 < pivot))
    sort(left) ++ [pivot] ++ sort(right)
  end
end
