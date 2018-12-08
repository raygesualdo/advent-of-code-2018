defmodule Day07Test do
  use ExUnit.Case, async: true

  alias Day07.Part1
  alias Day07.Part2

  test "solves part 1" do
    input = "
    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.
    "
    assert Part1.solve(input |> String.trim() |> String.split("\n", trim: true)) == "CABDFE"
  end

  test "solves part 2" do
    input = "
    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.
    "
    assert Part2.solve(input |> String.trim() |> String.split("\n", trim: true)) == 15
  end
end
