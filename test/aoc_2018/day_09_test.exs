defmodule Day09Test do
  use ExUnit.Case, async: true

  alias Day09.Part1
  # alias Day09.Part2

  test "solves part 1" do
    assert Part1.solve("10 players; last marble is worth 1618 points") == 8317
    assert Part1.solve("13 players; last marble is worth 7999 points") == 146_373
    assert Part1.solve("17 players; last marble is worth 1104 points") == 2764
    assert Part1.solve("21 players; last marble is worth 6111 points") == 54718
    assert Part1.solve("30 players; last marble is worth 5807 points") == 37305
  end

  # test "solves part 2" do
  #   assert Part2.solve(String.split("")) == :ok
  # end
end
