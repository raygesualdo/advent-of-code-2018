defmodule Day13 do
  defmodule Part1 do
    @moduledoc """
    A crop of this size requires significant logistics to transport produce, soil, fertilizer, and so on. The Elves are very busy pushing things around in carts on some kind of rudimentary system of tracks they've come up with.

    Seeing as how cart-and-track systems don't appear in recorded history for another 1000 years, the Elves seem to be making this up as they go along. They haven't even figured out how to avoid collisions yet.

    You map out the tracks (your puzzle input) and see where you can help.

    Tracks consist of straight paths (| and -), curves (/ and \), and intersections (+). Curves connect exactly two perpendicular pieces of track; for example, this is a closed loop:

    ```
    /----\
    |    |
    |    |
    \----/
    ```

    Intersections occur when two perpendicular paths cross. At an intersection, a cart is capable of turning left, turning right, or continuing straight. Here are two loops connected by two intersections:

    ```
    /-----\
    |     |
    |  /--+--\
    |  |  |  |
    \--+--/  |
       |     |
       \-----/
    ```

    Several carts are also on the tracks. Carts always face either up (^), down (v), left (<), or right (>). (On your initial map, the track under each cart is a straight path matching the direction the cart is facing.)

    Each time a cart has the option to turn (by arriving at any intersection), it turns left the first time, goes straight the second time, turns right the third time, and then repeats those directions starting again with left the fourth time, straight the fifth time, and so on. This process is independent of the particular intersection at which the cart has arrived - that is, the cart has no per-intersection memory.

    Carts all move at the same speed; they take turns moving a single step at a time. They do this based on their current location: carts on the top row move first (acting from left to right), then carts on the second row move (again from left to right), then carts on the third row, and so on. Once each cart has moved one step, the process repeats; each of these loops is called a tick.

    For example, suppose there are two carts on a straight track:

    ```
    |  |  |  |  |
    v  |  |  |  |
    |  v  v  |  |
    |  |  |  v  X
    |  |  ^  ^  |
    ^  ^  |  |  |
    |  |  |  |  |
    ```

    First, the top cart moves. It is facing down (v), so it moves down one square. Second, the bottom cart moves. It is facing up (^), so it moves up one square. Because all carts have moved, the first tick ends. Then, the process repeats, starting with the first cart. The first cart moves down, then the second cart moves up - right into the first cart, colliding with it! (The location of the crash is marked with an X.) This ends the second and last tick.

    Here is a longer example:

    ```
    /->-\
    |   |  /----\
    | /-+--+-\  |
    | | |  | v  |
    \-+-/  \-+--/
      \------/

    /-->\
    |   |  /----\
    | /-+--+-\  |
    | | |  | |  |
    \-+-/  \->--/
      \------/

    /---v
    |   |  /----\
    | /-+--+-\  |
    | | |  | |  |
    \-+-/  \-+>-/
      \------/

    /---\
    |   v  /----\
    | /-+--+-\  |
    | | |  | |  |
    \-+-/  \-+->/
      \------/

    /---\
    |   |  /----\
    | /->--+-\  |
    | | |  | |  |
    \-+-/  \-+--^
      \------/

    /---\
    |   |  /----\
    | /-+>-+-\  |
    | | |  | |  ^
    \-+-/  \-+--/
      \------/

    /---\
    |   |  /----\
    | /-+->+-\  ^
    | | |  | |  |
    \-+-/  \-+--/
      \------/

    /---\
    |   |  /----<
    | /-+-->-\  |
    | | |  | |  |
    \-+-/  \-+--/
      \------/

    /---\
    |   |  /---<\
    | /-+--+>\  |
    | | |  | |  |
    \-+-/  \-+--/
      \------/

    /---\
    |   |  /--<-\
    | /-+--+-v  |
    | | |  | |  |
    \-+-/  \-+--/
      \------/

    /---\
    |   |  /-<--\
    | /-+--+-\  |
    | | |  | v  |
    \-+-/  \-+--/
      \------/

    /---\
    |   |  /<---\
    | /-+--+-\  |
    | | |  | |  |
    \-+-/  \-<--/
      \------/

    /---\
    |   |  v----\
    | /-+--+-\  |
    | | |  | |  |
    \-+-/  \<+--/
      \------/

    /---\
    |   |  /----\
    | /-+--v-\  |
    | | |  | |  |
    \-+-/  ^-+--/
      \------/

    /---\
    |   |  /----\
    | /-+--+-\  |
    | | |  X |  |
    \-+-/  \-+--/
      \------/
    ```

    After following their respective paths for a while, the carts eventually crash. To help prevent crashes, you'd like to know the location of the first crash. Locations are given in X,Y coordinates, where the furthest left column is X=0 and the furthest top row is Y=0:

    ```
           111
     0123456789012
    0/---\
    1|   |  /----\
    2| /-+--+-\  |
    3| | |  X |  |
    4\-+-/  \-+--/
    5  \------/
    ```

    In this example, the location of the first crash is 7,3.
    """

    def solve(input) do
      {track, carts} =
        input
        |> Day13.Parser.parse()

      tick(track, carts)
    end

    def tick(track, carts) do
      carts
      |> Enum.sort()
      |> move_carts([], track)
      |> case do
        {:X, {x, y}} -> "#{x},#{y}"
        carts -> tick(track, carts)
      end
    end

    def move_carts([], moved_carts, _), do: moved_carts

    def move_carts(remaining_carts, moved_carts, track) do
      [current_cart | remaining_carts] = remaining_carts
      moved_cart = move_cart(current_cart, track)

      # case check_collision?(moved_cart, remaining_carts ++ moved_carts) do
      case check_collision?(moved_cart, moved_carts) do
        true -> {:X, elem(moved_cart, 1)}
        false -> move_carts(remaining_carts, [moved_cart | moved_carts], track)
      end
    end

    def move_cart({direction, coordinates, next_turn}, track) do
      updated_coordinates = get_next_coordinates(direction, coordinates)
      track_piece = Map.fetch!(track, updated_coordinates)
      {updated_direction, next_turn} = handle_turn(track_piece, direction, next_turn)
      {updated_direction, updated_coordinates, next_turn}
    end

    def handle_turn(:track_h, direction, next_turn), do: {direction, next_turn}
    def handle_turn(:track_v, direction, next_turn), do: {direction, next_turn}
    def handle_turn(:track_fs, :cart_n, next_turn), do: {:cart_e, next_turn}
    def handle_turn(:track_fs, :cart_e, next_turn), do: {:cart_n, next_turn}
    def handle_turn(:track_fs, :cart_s, next_turn), do: {:cart_w, next_turn}
    def handle_turn(:track_fs, :cart_w, next_turn), do: {:cart_s, next_turn}
    def handle_turn(:track_bs, :cart_n, next_turn), do: {:cart_w, next_turn}
    def handle_turn(:track_bs, :cart_w, next_turn), do: {:cart_n, next_turn}
    def handle_turn(:track_bs, :cart_s, next_turn), do: {:cart_e, next_turn}
    def handle_turn(:track_bs, :cart_e, next_turn), do: {:cart_s, next_turn}
    def handle_turn(:track_i, :cart_n, :turn_l), do: {:cart_w, :turn_s}
    def handle_turn(:track_i, :cart_n, :turn_s), do: {:cart_n, :turn_r}
    def handle_turn(:track_i, :cart_n, :turn_r), do: {:cart_e, :turn_l}
    def handle_turn(:track_i, :cart_s, :turn_l), do: {:cart_e, :turn_s}
    def handle_turn(:track_i, :cart_s, :turn_s), do: {:cart_s, :turn_r}
    def handle_turn(:track_i, :cart_s, :turn_r), do: {:cart_w, :turn_l}
    def handle_turn(:track_i, :cart_e, :turn_l), do: {:cart_n, :turn_s}
    def handle_turn(:track_i, :cart_e, :turn_s), do: {:cart_e, :turn_r}
    def handle_turn(:track_i, :cart_e, :turn_r), do: {:cart_s, :turn_l}
    def handle_turn(:track_i, :cart_w, :turn_l), do: {:cart_s, :turn_s}
    def handle_turn(:track_i, :cart_w, :turn_s), do: {:cart_w, :turn_r}
    def handle_turn(:track_i, :cart_w, :turn_r), do: {:cart_n, :turn_l}

    # North-western-most point is {0, 0}
    # Going north decrements y, going west decrements x
    def get_next_coordinates(:cart_n, {x, y}), do: {x, y - 1}
    def get_next_coordinates(:cart_s, {x, y}), do: {x, y + 1}
    def get_next_coordinates(:cart_e, {x, y}), do: {x + 1, y}
    def get_next_coordinates(:cart_w, {x, y}), do: {x - 1, y}

    def check_collision?({_, coordinates, _}, other_carts) do
      other_carts |> Enum.any?(fn x -> elem(x, 1) == coordinates end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    """

    def solve(input) do
      input
    end
  end

  defmodule Parser do
    @moduledoc """
    Parser for Day 13
    """

    def parse(input) do
      rows =
        input
        |> Enum.map(&String.to_charlist/1)
        |> Enum.with_index()

      for {row, y} <- rows, {char, x} <- Enum.with_index(row) do
        {char, {x, y}}
      end
      |> Enum.reduce({%{}, []}, &reduce_input/2)
    end

    def reduce_input({char, _}, acc) when char == 32, do: acc

    def reduce_input({char, coordinates}, {track, carts}) do
      char = char_to_atom(char)

      carts =
        case char do
          :cart_e -> [{char, coordinates, :turn_l} | carts]
          :cart_w -> [{char, coordinates, :turn_l} | carts]
          :cart_n -> [{char, coordinates, :turn_l} | carts]
          :cart_s -> [{char, coordinates, :turn_l} | carts]
          _ -> carts
        end

      track_piece =
        case char do
          :cart_e -> :track_h
          :cart_w -> :track_h
          :cart_n -> :track_v
          :cart_s -> :track_v
          _ -> char
        end

      track = Map.put(track, coordinates, track_piece)

      {track, carts}
    end

    def char_to_atom(?+), do: :track_i
    def char_to_atom(?-), do: :track_h
    def char_to_atom(?|), do: :track_v
    def char_to_atom(?/), do: :track_fs
    def char_to_atom(?\\), do: :track_bs
    def char_to_atom(?>), do: :cart_e
    def char_to_atom(?<), do: :cart_w
    def char_to_atom(?^), do: :cart_n
    def char_to_atom(?v), do: :cart_s
  end
end
