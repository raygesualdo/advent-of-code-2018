defmodule Aoc2018.Day03 do
  defmodule Part1 do
    @moduledoc """

    The Elves managed to locate the chimney-squeeze prototype fabric for Santa's suit (thanks to someone who helpfully wrote its box IDs on the wall of the warehouse in the middle of the night). Unfortunately, anomalies are still affecting them - nobody can even agree on how to cut the fabric.

    The whole piece of fabric they're working on is a very large square - at least 1000 inches on each side.

    Each Elf has made a claim about which area of fabric would be ideal for Santa's suit. All claims have an ID and consist of a single rectangle with edges parallel to the edges of the fabric. Each claim's rectangle is defined as follows:

    The number of inches between the left edge of the fabric and the left edge of the rectangle.
    The number of inches between the top edge of the fabric and the top edge of the rectangle.
    The width of the rectangle in inches.
    The height of the rectangle in inches.

    A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a rectangle 3 inches from the left edge, 2 inches from the top edge, 5 inches wide, and 4 inches tall. Visually, it claims the square inches of fabric represented by # (and ignores the square inches of fabric represented by .) in the diagram below:

    ```
    ...........
    ...........
    ...#####...
    ...#####...
    ...#####...
    ...#####...
    ...........
    ...........
    ...........
    ```

    The problem is that many of the claims overlap, causing two or more claims to cover part of the same areas. For example, consider the following claims:

    #1 @ 1,3: 4x4
    #2 @ 3,1: 4x4
    #3 @ 5,5: 2x2

    Visually, these claim the following areas:

    ```
    ........
    ...2222.
    ...2222.
    .11XX22.
    .11XX22.
    .111133.
    .111133.
    ........
    ```

    The four square inches marked with X are claimed by both 1 and 2. (Claim 3, while adjacent to the others, does not overlap either of them.)

    If the Elves all proceed with their own plans, none of them will have enough fabric. How many square inches of fabric are within two or more claims?
    """

    def solve(input) do
      input
      |> Enum.map(&parse_line/1)
      |> Enum.reduce(create_grid(), &place_square/2)
      |> Map.values()
      |> Enum.flat_map(&Map.values/1)
      |> Enum.count(fn x -> x == :overlap end)
    end

    def create_grid() do
      Enum.reduce(0..1000, %{}, fn y, grid ->
        row =
          Enum.reduce(0..1000, %{}, fn x, row ->
            Map.put(row, x, :empty)
          end)

        Map.put(grid, y, row)
      end)
    end

    def parse_line(line) do
      # "#17 @ 476,666: 29x23"
      ~r/#(?<id>\d+) @ (?<left>\d+),(?<top>\d+): (?<width>\d+)x(?<height>\d+)/
      |> Regex.named_captures(line, capture: :all_but_first)
      |> Enum.map(fn {key, value} -> {key, String.to_integer(value)} end)
      |> Enum.into(%{})
    end

    def place_square(square, grid) do
      fromY = square["top"]
      toY = square["top"] + square["height"] - 1
      fromX = square["left"]
      toX = square["left"] + square["width"] - 1

      Enum.reduce(fromY..toY, grid, fn y, grid ->
        row =
          Enum.reduce(fromX..toX, grid[y], fn x, row ->
            Map.update!(row, x, fn
              :empty -> :single_use
              _ -> :overlap
            end)
          end)

        Map.put(grid, y, row)
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Amidst the chaos, you notice that exactly one claim doesn't overlap by even a single square inch of fabric with any other claim. If you can somehow draw attention to it, maybe the Elves will be able to make Santa's suit after all!

    For example, in the claims above, only claim 3 is intact after all claims are made.

    What is the ID of the only claim that doesn't overlap?
    """

    def solve(input) do
      parsed_input =
        input
        |> Enum.map(&Aoc2018.Day03.Part1.parse_line/1)

      populated_grid =
        parsed_input
        |> Enum.reduce(Aoc2018.Day03.Part1.create_grid(), &Aoc2018.Day03.Part1.place_square/2)

      parsed_input
      |> Enum.reduce_while(populated_grid, &find_intact/2)
    end

    def find_intact(square, grid) do
      fromY = square["top"]
      toY = square["top"] + square["height"] - 1
      fromX = square["left"]
      toX = square["left"] + square["width"] - 1

      Enum.flat_map(fromY..toY, fn y ->
        Enum.map(fromX..toX, fn x ->
          get_in(grid, [y, x])
        end)
      end)
      |> Enum.into(%MapSet{})
      |> MapSet.to_list()
      |> case do
        [:single_use] -> {:halt, square["id"]}
        _ -> {:cont, grid}
      end
    end
  end
end
