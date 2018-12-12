defmodule Day11Test do
  use ExUnit.Case, async: true

  alias Day11.Part1
  alias Day11.Part2

  test "solves part 1" do
    assert Part1.solve("18") == "33,45"
    assert Part1.solve("42") == "21,61"
  end

  test "calculate_point_power/2" do
    assert Part1.calculate_point_power({122, 79}, 57) == -5
    assert Part1.calculate_point_power({217, 196}, 39) == 0
    assert Part1.calculate_point_power({101, 153}, 71) == 4
  end

  @tag :skip
  test "solves part 2" do
    assert Part2.solve("18") == "90,269,16"
    assert Part2.solve("42") == "232,251,12"
  end
end
