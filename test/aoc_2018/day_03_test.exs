defmodule Day03Test do
  use ExUnit.Case, async: true

  alias Day03.Part1
  # alias Day03.Part2

  test "solves part 1" do
    assert Part1.solve(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]) == 4
  end

  test "Part1.parse_line" do
    assert Part1.parse_line("#17 @ 476,666: 29x23") == %{
             "id" => 17,
             "left" => 476,
             "top" => 666,
             "width" => 29,
             "height" => 23
           }
  end

  test "Part1.create_grid" do
    grid = Part1.create_grid()
    assert grid[0][0] == :empty
    assert grid[1000][1000] == :empty
  end

  # test "solves part 2" do
  #   assert Part2.solve(String.split("")) == :ok
  # end
end
