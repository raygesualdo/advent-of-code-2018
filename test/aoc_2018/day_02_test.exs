defmodule Day02Test do
  use ExUnit.Case, async: true

  alias Day02.Part1
  alias Day02.Part2

  test "solves part 1" do
    assert Part1.solve(String.split("abcdef bababc abbcde abcccd aabcdd abcdee ababab")) == 12
  end

  test "Part1.group_by_count" do
    assert Part1.group_by_count(["a", "a", "b"]) == %{"a" => 2, "b" => 1}
  end

  test "solves part 2" do
    assert Part2.solve(String.split("abcde fghij klmno pqrst fguij axcye wvxyz")) == "fgij"
  end
end
