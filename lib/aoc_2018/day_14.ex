defmodule Day14 do
  defmodule Part1 do
    @moduledoc """
    You finally have a chance to look at all of the produce moving around. Chocolate, cinnamon, mint, chili peppers, nutmeg, vanilla... the Elves must be growing these plants to make hot chocolate! As you realize this, you hear a conversation in the distance. When you go to investigate, you discover two Elves in what appears to be a makeshift underground kitchen/laboratory.

    The Elves are trying to come up with the ultimate hot chocolate recipe; they're even maintaining a scoreboard which tracks the quality score (0-9) of each recipe.

    Only two recipes are on the board: the first recipe got a score of 3, the second, 7. Each of the two Elves has a current recipe: the first Elf starts with the first recipe, and the second Elf starts with the second recipe.

    To create new recipes, the two Elves combine their current recipes. This creates new recipes from the digits of the sum of the current recipes' scores. With the current recipes' scores of 3 and 7, their sum is 10, and so two new recipes would be created: the first with score 1 and the second with score 0. If the current recipes' scores were 2 and 3, the sum, 5, would only create one recipe (with a score of 5) with its single digit.

    The new recipes are added to the end of the scoreboard in the order they are created. So, after the first round, the scoreboard is 3, 7, 1, 0.

    After all new recipes are added to the scoreboard, each Elf picks a new current recipe. To do this, the Elf steps forward through the scoreboard a number of recipes equal to 1 plus the score of their current recipe. So, after the first round, the first Elf moves forward 1 + 3 = 4 times, while the second Elf moves forward 1 + 7 = 8 times. If they run out of recipes, they loop back around to the beginning. After the first round, both Elves happen to loop around until they land on the same recipe that they had in the beginning; in general, they will move to different recipes.

    Drawing the first Elf as parentheses and the second Elf as square brackets, they continue this process:

    ```
    (3)[7]
    (3)[7] 1  0
     3  7  1 [0](1) 0 # From 1 to 1 by 3 with size 6
     3  7  1  0 [1] 0 (1)
    (3) 7  1  0  1  0 [1] 2
     3  7  1  0 (1) 0  1  2 [4]
     3  7  1 [0] 1  0 (1) 2  4  5
     3  7  1  0 [1] 0  1  2 (4) 5  1
     3 (7) 1  0  1  0 [1] 2  4  5  1  5
     3  7  1  0  1  0  1  2 [4](5) 1  5  8
     3 (7) 1  0  1  0  1  2  4  5  1  5  8 [9]
     3  7  1  0  1  0  1 [2] 4 (5) 1  5  8  9  1  6
     3  7  1  0  1  0  1  2  4  5 [1] 5  8  9  1 (6) 7
     3  7  1  0 (1) 0  1  2  4  5  1  5 [8] 9  1  6  7  7
     3  7 [1] 0  1  0 (1) 2  4  5  1  5  8  9  1  6  7  7  9
     3  7  1  0 [1] 0  1  2 (4) 5  1  5  8  9  1  6  7  7  9  2
    ```

    The Elves think their skill will improve after making a few recipes (your puzzle input). However, that could take ages; you can speed this up considerably by identifying the scores of the ten recipes after that. For example:

    If the Elves think their skill will improve after making 9 recipes, the scores of the ten recipes after the first nine on the scoreboard would be 5158916779 (highlighted in the last line of the diagram).
    After 5 recipes, the scores of the next ten would be 0124515891.
    After 18 recipes, the scores of the next ten would be 9251071085.
    After 2018 recipes, the scores of the next ten would be 5941429882.

    What are the scores of the ten recipes immediately after the number of recipes in your puzzle input?
    """
    @start %{1 => 3, 2 => 7}

    def solve(input) do
      input
      |> String.to_integer()
      |> iterate(@start)
    end

    def iterate(input, recipies), do: iterate(input + 10, recipies, {1, 2})

    def iterate(ceiling, recipies, _) when map_size(recipies) > ceiling do
      size = Map.size(recipies)
      differential = Map.size(recipies) - ceiling - 1

      for n <- (-10 - differential)..(-1 - differential) do
        recipies |> Map.fetch!(size + n)
      end
      |> Enum.map_join(&to_string/1)
    end

    def iterate(ceiling, recipies, {index1, index2}) do
      recipe1 = Map.fetch!(recipies, index1)
      recipe2 = Map.fetch!(recipies, index2)

      recipies = make_recipies(recipe1, recipe2, recipies)

      index1 = get_next_index(index1, recipe1, Map.size(recipies))
      index2 = get_next_index(index2, recipe2, Map.size(recipies))

      iterate(ceiling, recipies, {index1, index2})
    end

    def make_recipies(r1, r2, recipies) do
      sum = r1 + r2
      last_index = Map.size(recipies)

      if sum < 10 do
        recipies |> Map.put(last_index + 1, sum)
      else
        i1 = div(sum, 10)
        i2 = rem(sum, 10)
        recipies |> Map.put(last_index + 1, i1) |> Map.put(last_index + 2, i2)
      end
    end

    def get_next_index(index, recipe, recipe_count),
      do: get_next_index(index + recipe + 1, recipe_count)

    def get_next_index(index, recipe_count) do
      case index > recipe_count do
        true -> get_next_index(index - recipe_count, recipe_count)
        false -> index
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    As it turns out, you got the Elves' plan backwards. They actually want to know how many recipes appear on the scoreboard to the left of the first recipes whose scores are the digits from your puzzle input.

    51589 first appears after 9 recipes.
    01245 first appears after 5 recipes.
    92510 first appears after 18 recipes.
    59414 first appears after 2018 recipes.

    How many recipes appear on the scoreboard to the left of the score sequence in your puzzle input?
    """
    alias Day14.Part1
    @start %{1 => 3, 2 => 7}

    def solve(input) do
      input
      |> String.split("", trim: true)
      |> Enum.with_index(1)
      |> Enum.map(fn {n, i} -> {i, String.to_integer(n)} end)
      |> Enum.into(%{})
      |> iterate(@start)
    end

    def iterate(input, recipies),
      do: iterate(input, recipies, {1, 2})

    def iterate(input, recipies, {index1, index2}) do
      recipe1 = Map.fetch!(recipies, index1)
      recipe2 = Map.fetch!(recipies, index2)

      recipies = Part1.make_recipies(recipe1, recipe2, recipies)

      index1 = Part1.get_next_index(index1, recipe1, Map.size(recipies))
      index2 = Part1.get_next_index(index2, recipe2, Map.size(recipies))

      cond do
        last_n_entries_match?(recipies, input) -> Map.size(recipies) - Map.size(input)
        last_n_entries_match?(recipies, input, 1) -> Map.size(recipies) - Map.size(input) - 1
        true -> iterate(input, recipies, {index1, index2})
      end
    end

    def last_n_entries_match?(map, input, offset \\ 0) do
      size = Map.size(map)
      input_size = Map.size(input)

      if size - offset < input_size do
        false
      else
        Enum.reduce_while(-(input_size + offset)..(-1 - offset), true, fn key, _ ->
          if Map.fetch!(map, size + key + 1) == Map.fetch!(input, input_size + key + 1 + offset),
            do: {:cont, true},
            else: {:halt, false}
        end)
      end
    end
  end
end
