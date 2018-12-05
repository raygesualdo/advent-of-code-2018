defmodule Day05Test do
  use ExUnit.Case, async: true

  alias Day05.Part1
  alias Day05.Part2

  test "solves part 1" do
    assert Part1.solve("dabAcCaCBAcCcaDA") == 10
  end

  test "solves part 2" do
    assert Part2.solve("dabAcCaCBAcCcaDA") == 4
  end
end
