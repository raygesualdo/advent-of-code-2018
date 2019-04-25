defmodule Day17 do
  defmodule Parser do
    @x_leading_regex ~r/x=(\d+), y=(\d+)..(\d+)/
    @y_leading_regex ~r/y=(\d+), x=(\d+)..(\d+)/

    def parse_input(input) do
      input
      |> Enum.map(&parse_line/1)
      |> Enum.reduce(%MapSet{}, &MapSet.union/2)
    end

    def parse_line(line) do
      if String.starts_with?(line, "x") do
        [x, y1, y2] =
          Regex.run(@x_leading_regex, line, capture: :all_but_first)
          |> Enum.map(&String.to_integer/1)

        for y <- y1..y2 do
          {x, y}
        end
      else
        String.starts_with?(line, "y")

        [y, x1, x2] =
          Regex.run(@y_leading_regex, line, capture: :all_but_first)
          |> Enum.map(&String.to_integer/1)

        for x <- x1..x2 do
          {x, y}
        end
      end
      |> MapSet.new()
    end
  end

  defmodule Part1 do
    @moduledoc """
    You arrive in the year 18. If it weren't for the coat you got in 1018, you would be very cold: the North Pole base hasn't even been constructed.

    Rather, it hasn't been constructed yet. The Elves are making a little progress, but there's not a lot of liquid water in this climate, so they're getting very dehydrated. Maybe there's more underground?

    You scan a two-dimensional vertical slice of the ground nearby and discover that it is mostly sand with veins of clay. The scan only provides data with a granularity of square meters, but it should be good enough to determine how much water is trapped there. In the scan, x represents the distance to the right, and y represents the distance down. There is also a spring of water near the surface at x=500, y=0. The scan identifies which square meters are clay (your puzzle input).

    For example, suppose your scan shows the following veins of clay:

    ```
    x=495, y=2..7
    y=7, x=495..501
    x=501, y=3..7
    x=498, y=2..4
    x=506, y=1..2
    x=498, y=10..13
    x=504, y=10..13
    y=13, x=498..504
    ```

    Rendering clay as #, sand as ., and the water spring as +, and with x increasing to the right and y increasing downward, this becomes:

    ```
       44444455555555
       99999900000000
       45678901234567
     0 ......+.......
     1 ............#.
     2 .#..#.......#.
     3 .#..#..#......
     4 .#..#..#......
     5 .#.....#......
     6 .#.....#......
     7 .#######......
     8 ..............
     9 ..............
    10 ....#.....#...
    11 ....#.....#...
    12 ....#.....#...
    13 ....#######...
    ```

    The spring of water will produce water forever. Water can move through sand, but is blocked by clay. Water always moves down when possible, and spreads to the left and right otherwise, filling space that has clay on both sides and falling out otherwise.

    For example, if five squares of water are created, they will flow downward until they reach the clay and settle there. Water that has come to rest is shown here as ~, while sand through which water has passed (but which is now dry again) is shown as |:

    ```
    ......+.......
    ......|.....#.
    .#..#.|.....#.
    .#..#.|#......
    .#..#.|#......
    .#....|#......
    .#~~~~~#......
    .#######......
    ..............
    ..............
    ....#.....#...
    ....#.....#...
    ....#.....#...
    ....#######...
    ```

    Two squares of water can't occupy the same location. If another five squares of water are created, they will settle on the first five, filling the clay reservoir a little more:

    ```
    ......+.......
    ......|.....#.
    .#..#.|.....#.
    .#..#.|#......
    .#..#.|#......
    .#~~~~~#......
    .#~~~~~#......
    .#######......
    ..............
    ..............
    ....#.....#...
    ....#.....#...
    ....#.....#...
    ....#######...
    ```

    Water pressure does not apply in this scenario. If another four squares of water are created, they will stay on the right side of the barrier, and no water will reach the left side:

    ```
    ......+.......
    ......|.....#.
    .#..#.|.....#.
    .#..#~~#......
    .#..#~~#......
    .#~~~~~#......
    .#~~~~~#......
    .#######......
    ..............
    ..............
    ....#.....#...
    ....#.....#...
    ....#.....#...
    ....#######...
    ```

    At this point, the top reservoir overflows. While water can reach the tiles above the surface of the water, it cannot settle there, and so the next five squares of water settle like this:

    ```
    ......+.......
    ......|.....#.
    .#..#||||...#.
    .#..#~~#|.....
    .#..#~~#|.....
    .#~~~~~#|.....
    .#~~~~~#|.....
    .#######|.....
    ........|.....
    ........|.....
    ....#...|.#...
    ....#...|.#...
    ....#~~~~~#...
    ....#######...
    ```

    Note especially the leftmost |: the new squares of water can reach this tile, but cannot stop there. Instead, eventually, they all fall to the right and settle in the reservoir below.

    After 10 more squares of water, the bottom reservoir is also full:

    ```
    ......+.......
    ......|.....#.
    .#..#||||...#.
    .#..#~~#|.....
    .#..#~~#|.....
    .#~~~~~#|.....
    .#~~~~~#|.....
    .#######|.....
    ........|.....
    ........|.....
    ....#~~~~~#...
    ....#~~~~~#...
    ....#~~~~~#...
    ....#######...
    ```

    Finally, while there is nowhere left for the water to settle, it can reach a few more tiles before overflowing beyond the bottom of the scanned data:

    ```
    ......+.......    (line not counted: above minimum y value)
    ......|.....#.
    .#..#||||...#.
    .#..#~~#|.....
    .#..#~~#|.....
    .#~~~~~#|.....
    .#~~~~~#|.....
    .#######|.....
    ........|.....
    ...|||||||||..
    ...|#~~~~~#|..
    ...|#~~~~~#|..
    ...|#~~~~~#|..
    ...|#######|..
    ...|.......|..    (line not counted: below maximum y value)
    ...|.......|..    (line not counted: below maximum y value)
    ...|.......|..    (line not counted: below maximum y value)
    ```

    How many tiles can be reached by the water? To prevent counting forever, ignore tiles with a y coordinate smaller than the smallest y coordinate in your scan data or larger than the largest one. Any x coordinate is valid. In this example, the lowest y coordinate given is 1, and the highest is 13, causing the water spring (in row 0) and the water falling off the bottom of the render (in rows 14 through infinity) to be ignored.

    So, in the example above, counting both water at rest (~) and other sand tiles the water can hypothetically reach (|), the total number of tiles the water can reach is 57.

    How many tiles can the water reach within the range of y values in your scan?
    """
    import Aoc2018

    def solve(input) do
      clay =
        input
        |> Parser.parse_input()

      {min_y, max_y} =
        clay
        |> Enum.map(&elem(&1, 1))
        |> Enum.min_max()

      starting_point = {500, min_y}

      # print(clay)
      a = fall(starting_point, clay, max_y)

      # log(
      #   a
      #   |> MapSet.to_list()
      #   |> Enum.sort_by(fn {x, y} -> "#{String.pad_leading(to_string(y), 4, "0")},#{x}" end),
      #   "water"
      # )

      a |> MapSet.size()
    end

    def print(clay) do
      {min_x, max_x} =
        clay
        |> Enum.map(&elem(&1, 0))
        |> Enum.min_max()

      {min_y, max_y} =
        clay
        |> Enum.map(&elem(&1, 1))
        |> Enum.min_max()

      starting_point = {500, min_y}

      columns =
        for x <- min_x..max_x do
          rem(x, 10)
        end
        |> Enum.join()
        |> String.replace_prefix("", String.pad_leading("", 5))

      grid =
        for y <- min_y..max_y do
          for x <- min_x..max_x do
            cond do
              {x, y} == starting_point -> "+"
              MapSet.member?(clay, {x, y}) -> "#"
              true -> "."
            end
          end
          |> Enum.join()
          |> String.replace_prefix("", String.pad_leading(to_string(y), 4) <> " ")
        end
        |> Enum.join("\n")
        |> String.replace_prefix("", "\n")

      "\n" <> columns <> grid <> "\n" <> columns
    end

    def fall(starting_point, clay, max_y) do
      fall(starting_point, %MapSet{}, clay, max_y)
    end

    def fall({_, y}, water, _, max_y) when y > max_y, do: water

    def fall({x, y} = point, water, clay, max_y) do
      if y == 1813, do: log({point, MapSet.size(water)}, "fall")
      water = water |> MapSet.put(point)

      if MapSet.member?(clay, {x, y + 1}) do
        spread(point, water, clay, max_y)
      else
        fall({x, y + 1}, water, clay, max_y)
      end
    end

    def spread({x, y} = point, water, clay, max_y) do
      log({point}, "spread")
      water = water |> MapSet.put(point)
      {left_result, left_water, left_point} = spread_left(point, water, clay)
      {right_result, right_water, right_point} = spread_right(point, water, clay)
      # IO.inspect({left_result, right_result, left_water, right_water})
      water = water |> MapSet.union(left_water) |> MapSet.union(right_water)

      if point == {560, 1800},
        do: log({left_result, left_point, right_result, right_point}, "fall in spread")

      cond do
        left_result == :end and right_result == :end ->
          spread({x, y - 1}, water, clay, max_y)

        left_result == :fall and right_result == :end ->
          fall(left_point, water, clay, max_y)

        left_result == :end and right_result == :fall ->
          fall(right_point, water, clay, max_y)

        left_result == :fall and right_result == :fall ->
          MapSet.union(
            fall(left_point, water, clay, max_y),
            fall(right_point, water, clay, max_y)
          )
      end
    end

    def spread_left(point, water, clay), do: spread_out(point, water, clay, :left)

    def spread_right(point, water, clay), do: spread_out(point, water, clay, :right)

    def spread_out({x, y}, water, clay, direction) do
      new_x = if direction == :left, do: x - 1, else: x + 1
      point = {new_x, y}

      if point == {496, 2}, do: log({point, water, clay, direction}, "496, 2")

      if MapSet.member?(clay, point) do
        {:end, water, point}
      else
        point_below = {new_x, y + 1}

        water =
          water
          |> MapSet.put(point)

        if MapSet.member?(water, point_below) or MapSet.member?(clay, point_below) do
          spread_out(point, water, clay, direction)
        else
          {:fall, water, point}
        end
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    """

    def solve(input) do
      input
    end
  end
end
