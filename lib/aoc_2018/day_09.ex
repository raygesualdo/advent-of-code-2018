defmodule Day09 do
  defmodule Part1 do
    @moduledoc """
    You talk to the Elves while you wait for your navigation system to initialize. To pass the time, they introduce you to their favorite marble game.

    The Elves play this game by taking turns arranging the marbles in a circle according to very particular rules. The marbles are numbered starting with 0 and increasing by 1 until every marble has a number.

    First, the marble numbered 0 is placed in the circle. At this point, while it contains only a single marble, it is still a circle: the marble is both clockwise from itself and counter-clockwise from itself. This marble is designated the current marble.

    Then, each Elf takes a turn placing the lowest-numbered remaining marble into the circle between the marbles that are 1 and 2 marbles clockwise of the current marble. (When the circle is large enough, this means that there is one marble between the marble that was just placed and the current marble.) The marble that was just placed then becomes the current marble.

    However, if the marble that is about to be placed has a number which is a multiple of 23, something entirely different happens. First, the current player keeps the marble they would have placed, adding it to their score. In addition, the marble 7 marbles counter-clockwise from the current marble is removed from the circle and also added to the current player's score. The marble located immediately clockwise of the marble that was removed becomes the new current marble.

    For example, suppose there are 9 players. After the marble with value 0 is placed in the middle, each player (shown in square brackets) takes a turn. The result of each of those turns would produce circles of marbles like this, where clockwise is to the right and the resulting current marble is in parentheses:

    ```
    [-] (0)
    [1]  0 (1)
    [2]  0 (2) 1
    [3]  0  2  1 (3)
    [4]  0 (4) 2  1  3
    [5]  0  4  2 (5) 1  3
    [6]  0  4  2  5  1 (6) 3
    [7]  0  4  2  5  1  6  3 (7)
    [8]  0 (8) 4  2  5  1  6  3  7
    [9]  0  8  4 (9) 2  5  1  6  3  7
    [1]  0  8  4  9  2(10) 5  1  6  3  7
    [2]  0  8  4  9  2 10  5(11) 1  6  3  7
    [3]  0  8  4  9  2 10  5 11  1(12) 6  3  7
    [4]  0  8  4  9  2 10  5 11  1 12  6(13) 3  7
    [5]  0  8  4  9  2 10  5 11  1 12  6 13  3(14) 7
    [6]  0  8  4  9  2 10  5 11  1 12  6 13  3 14  7(15)
    [7]  0(16) 8  4  9  2 10  5 11  1 12  6 13  3 14  7 15
    [8]  0 16  8(17) 4  9  2 10  5 11  1 12  6 13  3 14  7 15
    [9]  0 16  8 17  4(18) 9  2 10  5 11  1 12  6 13  3 14  7 15
    [1]  0 16  8 17  4 18  9(19) 2 10  5 11  1 12  6 13  3 14  7 15
    [2]  0 16  8 17  4 18  9 19  2(20)10  5 11  1 12  6 13  3 14  7 15
    [3]  0 16  8 17  4 18  9 19  2 20 10(21) 5 11  1 12  6 13  3 14  7 15
    [4]  0 16  8 17  4 18  9 19  2 20 10 21  5(22)11  1 12  6 13  3 14  7 15
    [5]  0 16  8 17  4 18(19) 2 20 10 21  5 22 11  1 12  6 13  3 14  7 15
    [6]  0 16  8 17  4 18 19  2(24)20 10 21  5 22 11  1 12  6 13  3 14  7 15
    [7]  0 16  8 17  4 18 19  2 24 20(25)10 21  5 22 11  1 12  6 13  3 14  7 15
    ```

    The goal is to be the player with the highest score after the last marble is used up. Assuming the example above ends after the marble numbered 25, the winning score is 23+9=32 (because player 5 kept marble 23 and removed marble 9, while no other player got any points in this very short example game).

    Here are a few more examples:

    `10` players; last marble is worth `1618` points: high score is `8317`
    `13` players; last marble is worth `7999` points: high score is `146373`
    `17` players; last marble is worth `1104` points: high score is `2764`
    `21` players; last marble is worth `6111` points: high score is `54718`
    `30` players; last marble is worth `5807` points: high score is `37305`

    What is the winning Elf's score?
    """

    defmodule Game do
      defstruct [
        :players,
        :circle,
        :circle_size,
        :num_of_players,
        :current_index,
        :endgame_trigger,
        :finished
      ]

      def new(num_of_players, endgame_trigger) do
        %Game{
          players: create_players(num_of_players),
          num_of_players: num_of_players,
          circle: [0],
          circle_size: 1,
          current_index: 0,
          endgame_trigger: endgame_trigger,
          finished: false
        }
      end

      def run(game, round \\ 0) do
        game =
          Enum.reduce_while(0..(game.num_of_players - 1), game, fn player_index, game ->
            marble = player_index + 1 + game.num_of_players * round

            {points, circle, circle_size, current_index} =
              place_marble(game.circle, game.circle_size, game.current_index, marble)

            game =
              game
              |> Map.put(:circle, circle)
              |> Map.put(:circle_size, circle_size)
              |> Map.put(:current_index, current_index)
              |> Map.put(
                :players,
                if points == 0 do
                  game.players
                else
                  List.update_at(game.players, player_index, &(&1 + points))
                end
              )

            cond do
              game.endgame_trigger == marble -> {:halt, %{game | finished: true}}
              true -> {:cont, game}
            end
          end)

        cond do
          game.finished == true -> game
          true -> run(game, round + 1)
        end
      end

      defp place_marble([0], _, _, _), do: {0, [1, 0], 2, 0}

      defp place_marble(circle, circle_size, current_index, marble) when rem(marble, 23) == 0 do
        index_to_pop = get_pop_index(current_index, circle_size)
        {popped_marble, circle} = List.pop_at(circle, index_to_pop)
        {marble + popped_marble, circle, circle_size - 1, index_to_pop - 1}
      end

      defp place_marble(circle, circle_size, current_index, marble) do
        index_to_insert = get_insert_index(current_index, circle_size)
        circle = circle |> List.insert_at(index_to_insert, marble)
        {0, circle, circle_size + 1, index_to_insert}
      end

      defp get_insert_index(current_index, list_length) do
        cond do
          current_index == 0 -> list_length - 1
          true -> current_index - 1
        end
      end

      defp get_pop_index(current_index, list_length) do
        cond do
          current_index + 7 >= list_length -> current_index + 7 - list_length
          true -> current_index + 7
        end
      end

      def get_highest_score(game), do: Enum.max(game.players)

      defp create_players(num_of_players) do
        for _ <- 1..num_of_players, do: 0
      end
    end

    def solve(input) do
      [num_of_players, last_point_total] = parse(input)

      Game.new(num_of_players, last_point_total)
      |> Game.run()
      |> Game.get_highest_score()
    end

    def parse(input),
      do:
        Regex.run(~r/(\d+) .+ (\d+)/, input, capture: :all_but_first)
        |> Enum.map(&String.to_integer/1)
  end

  defmodule Part2 do
    @moduledoc """
    """

    import Day09.Part1

    defmodule State do
      @moduledoc """
      Struct for storing the current state of the circle, scoreboard, and number of players
      """
      defstruct circle: {[], [0]}, scores: %{}, num: 0
    end

    def solve(input) do
      [num_of_players, final_marble] = parse(input)

      state = place_marble(%State{num: num_of_players}, 1, final_marble * 100)

      state.scores
      |> Map.values()
      |> Enum.max()
    end

    # last marble has been placed, game is over
    def place_marble(state, current, last) when current > last do
      state
    end

    # when next marble is a multiple of 23, move 7 to the left, remove it
    # Add the value of the removed marble and the next marble to that players score
    def place_marble(state, marble, last) when rem(marble, 23) == 0 do
      circle = move_left(state.circle, 7)

      # pop the current marble
      current = get_current(circle)
      circle = remove(circle)

      # figure out the player and update the scoreboard
      player = rem(marble, state.num)
      scores = Map.update(state.scores, player, current + marble, &(&1 + current + marble))

      # update state with new scores and new circle
      %State{state | scores: scores, circle: circle}
      |> place_marble(marble + 1, last)
    end

    # normal turn, rotate the circle and push the new marble
    def place_marble(state, marble, last) do
      %State{
        state
        | circle:
            state.circle
            |> move_right(2)
            |> add(marble)
      }
      |> place_marble(marble + 1, last)
    end

    # move left by 0? easy
    def move_left(circle, 0), do: circle

    # if left list is empty, reverse the right list and set it as the left
    def move_left({[], right}, steps) do
      [current | reversed] = Enum.reverse(right)

      # move the head of the left list over to the right.  The right list is never allowed
      # to be empty as its head is always the current marble
      move_left({reversed, [current]}, steps - 1)
    end

    # pop the head off the left list and push it onto the right
    def move_left({[prev | left], right}, steps) do
      move_left({left, [prev | right]}, steps - 1)
    end

    # move right by 0? easy
    def move_right(circle, 0), do: circle

    # if right list is empty, reverse the left list and set it as the right
    def move_right({left, [current]}, steps) do
      move_right({[], Enum.reverse([current | left])}, steps - 1)
    end

    # pop the head off the right list and push it into the right
    def move_right({left, [current | right]}, steps) do
      move_right({[current | left], right}, steps - 1)
    end

    # adds the new marble to the left of the current marble
    def add({left, right}, marble) do
      {left, [marble | right]}
    end

    # removes the current marble
    def remove({left, [_current | right]}) do
      {left, right}
    end

    # returns the current marble
    def get_current({_, [current | _]}), do: current
  end
end
