defmodule Aoc2018.Day01Test do
  use ExUnit.Case, async: true

  alias Aoc2018.Day01.Part1
  alias Aoc2018.Day01.Part2

  test "solves the first problem" do
    assert Part1.solve(String.split("+1 +10 -3")) == 8
    assert Part1.solve(String.split("+1 +1 -2")) == 0
    assert Part1.solve(String.split("-1 -2 -3")) == -6
  end

  test "solves the second problem" do
    assert Part2.solve(String.split("+1 -1")) == 0
    assert Part2.solve(String.split("+3 +3 +4 -2 -4")) == 10
    assert Part2.solve(String.split("-6 +3 +8 +5 -6")) == 5
  end
end
