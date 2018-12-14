defmodule Aoc2018 do
  def read_file(day) do
    File.read!("data/day#{day}.txt")
    |> String.split(~r/\R/, trim: true)

    # |> Enum.map(&String.trim/1)
  end

  def input(day) do
    data = read_file(day)

    if length(data) == 1, do: List.first(data), else: data
  end

  def log(any), do: IO.inspect(any)
  def log(any, label), do: IO.inspect(any, label: label)
end
