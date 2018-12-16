defmodule Day14Test do
  use ExUnit.Case, async: true

  alias Day14.Part1
  alias Day14.Part2

  test "solves part 1" do
    assert Part1.solve("9") == "5158916779"
    assert Part1.solve("5") == "0124515891"
    assert Part1.solve("18") == "9251071085"
  end

  @tag :skip
  test "Part1.get_next_index/3" do
    assert Part1.get_next_index(0, 1, 4) == 2
    assert Part1.get_next_index(0, 0, 5) == 4
    assert Part1.get_next_index(1, 1, 5) == 4
    assert Part1.get_next_index(1, 3, 4) == 1
    assert Part1.get_next_index(7, 1, 10) == 5
  end

  test "solves part 2" do
    assert Part2.solve("51589") == 9
    assert Part2.solve("5158916") == 9
    assert Part2.solve("01245") == 5
    assert Part2.solve("92510") == 18
    assert Part2.solve("59414") == 2018
  end
end
