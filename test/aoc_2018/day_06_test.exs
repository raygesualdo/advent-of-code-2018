defmodule Day06Test do
  use ExUnit.Case, async: true

  alias Day06.Part1
  # alias Day06.Part2

  test "solves part 1" do
    input = """
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """

    assert Part1.solve(String.split(input, "\n", trim: true)) == 17
  end

  # test "solves part 2" do
  #   input = """
  #   1, 1
  #   1, 6
  #   8, 3
  #   3, 4
  #   5, 5
  #   8, 9
  #   """

  #   assert Part2.solve(String.split(input, "\n", trim: true)) == 16
  # end
end
