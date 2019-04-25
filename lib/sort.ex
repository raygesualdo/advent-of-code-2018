defmodule Sort do
  import Aoc2018

  def quicksort([]), do: []

  def quicksort([head | tail]) do
    {less_than, greater_than} = Enum.split_with(tail, &(&1 < head))
    log(head, "head")
    log(tail, "tail")
    log(less_than, "less_than")
    log(greater_than, "greater_than")
    quicksort(less_than) ++ [head] ++ quicksort(greater_than)
  end

  def generate_list(list_length \\ 10) do
    for n <- 1..list_length do
      n
    end
    |> Enum.shuffle()
  end
end
