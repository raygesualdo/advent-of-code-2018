defmodule Aoc2018.Day02Test do
  use ExUnit.Case, async: true

  alias Aoc2018.Day02.Part1
  # alias Aoc2018.Day02.Part2

  test "solves part 1" do
    assert Part1.solve(String.split("abcdef bababc abbcde abcccd aabcdd abcdee ababab")) == 12
  end

  test "Part1.group_by_count" do
    assert Part1.group_by_count(["a", "a", "b"]) == %{"a" => 2, "b" => 1}
  end
end
