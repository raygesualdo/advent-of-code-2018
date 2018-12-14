defmodule Day13Test do
  use ExUnit.Case, async: true

  alias Day13.Part1
  # alias Day13.Part2

  # @tag :skip
  test "solves part 1" do
    input =
      ~S"""
      /->-\
      |   |  /----\
      | /-+--+-\  |
      | | |  | v  |
      \-+-/  \-+--/
        \------/
      """
      |> String.split("\n", trim: true)

    assert Part1.solve(input) == "7,3"
  end

  test "Part1.get_next_coordinates/1" do
    assert Part1.get_next_coordinates(:cart_n, {3, 3}) == {3, 2}
    assert Part1.get_next_coordinates(:cart_s, {3, 3}) == {3, 4}
    assert Part1.get_next_coordinates(:cart_e, {3, 3}) == {4, 3}
    assert Part1.get_next_coordinates(:cart_w, {3, 3}) == {2, 3}
  end

  # test "solves part 2" do
  #   assert Part2.solve(String.split("")) == :ok
  # end
end
