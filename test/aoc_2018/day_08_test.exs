defmodule Day08Test do
  use ExUnit.Case, async: true

  alias Day08.Part1
  alias Day08.Part2

  test "solves part 1" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    assert Part1.solve(input) == 138
  end

  test "solves part 2" do
    input = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    assert Part2.solve(input) == 66
  end
end
