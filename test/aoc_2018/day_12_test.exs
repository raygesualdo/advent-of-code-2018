defmodule Day12Test do
  use ExUnit.Case, async: true

  alias Day12.Part1
  # alias Day12.Part2

  test "solves part 1" do
    input =
      """
      initial state: #..#.#..##......###...###

      ...## => #
      ..#.. => #
      .#... => #
      .#.#. => #
      .#.## => #
      .##.. => #
      .#### => #
      #.#.# => #
      #.### => #
      ##.#. => #
      ##.## => #
      ###.. => #
      ###.# => #
      ####. => #
      """
      |> String.split("\n", trim: true)

    assert Part1.solve(input) == 325
  end

  # test "solves part 2" do
  #   assert Part2.solve(String.split("")) == :ok
  # end
end
