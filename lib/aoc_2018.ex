defmodule Aoc2018 do
  def read_file(day) do
    File.read!("data/day#{day}.txt")
    |> String.split(~r/\R/, trim: true)
    |> Enum.map(&String.trim/1)
  end

  def input(day) do
    read_file(day)
  end
end
