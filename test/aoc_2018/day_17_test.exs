defmodule Day17Test do
  use ExUnit.Case, async: true

  alias Day17.Part1
  # alias Day17.Part2

  @tag timeout: 5000
  @tag :skip
  test "solves part 1" do
    input =
      """
      x=495, y=2..7
      y=7, x=495..501
      x=501, y=3..7
      x=498, y=2..4
      x=506, y=1..2
      x=498, y=10..13
      x=504, y=10..13
      y=13, x=498..504
      """
      |> String.split("\n", trim: true)

    assert Part1.solve(input) == 57
  end

  #    44444455555555
  #    99999900000000
  #    45678901234567
  #  0 ......+.......
  #  1 ......|.....#. 1
  #  2 .#|||||||...#. 7
  #  3 .#~~~~~#|..... 6
  #  4 .#~#~#~#|..... 4
  #  5 .#~###~#|..... 3
  #  6 .#~~~~~#|..... 6
  #  7 .#######|..... 1
  #  8 ........|..... 1
  #  9 ...|||||||||.. 9
  # 10 ...|#~~~~~#|.. 7
  # 11 ...|#~~~~~#|.. 7
  # 12 ...|#~~~~~#|.. 7
  # 13 ...|#######|.. 2

  test "solves part 1, iteration 2" do
    input =
      """
      x=495, y=2..7
      y=7, x=495..501
      x=501, y=3..7
      x=497, y=4..5
      y=5, x=497..499
      x=499, y=4..5
      x=506, y=1..2
      x=498, y=10..13
      x=504, y=10..13
      y=13, x=498..504
      """
      |> String.split("\n", trim: true)

    assert Part1.solve(input) == 61
  end

  # test "solves part 2" do
  #   assert Part2.solve(String.split("")) == :ok
  # end
end
