defmodule Day07 do
  defmodule Part1 do
    @moduledoc """
    You find yourself standing on a snow-covered coastline; apparently, you landed a little off course. The region is too hilly to see the North Pole from here, but you do spot some Elves that seem to be trying to unpack something that washed ashore. It's quite cold out, so you decide to risk creating a paradox by asking them for directions.

    "Oh, are you the search party?" Somehow, you can understand whatever Elves from the year 1018 speak; you assume it's Ancient Nordic Elvish. Could the device on your wrist also be a translator? "Those clothes don't look very warm; take this." They hand you a heavy coat.

    "We do need to find our way back to the North Pole, but we have higher priorities at the moment. You see, believe it or not, this box contains something that will solve all of Santa's transportation problems - at least, that's what it looks like from the pictures in the instructions." It doesn't seem like they can read whatever language it's in, but you can: "Sleigh kit. Some assembly required."

    "'Sleigh'? What a wonderful name! You must help us assemble this 'sleigh' at once!" They start excitedly pulling more parts out of the box.

    The instructions specify a series of steps and requirements about which steps must be finished before others can begin (your puzzle input). Each step is designated by a single letter. For example, suppose you have the following instructions:

    Step C must be finished before step A can begin.
    Step C must be finished before step F can begin.
    Step A must be finished before step B can begin.
    Step A must be finished before step D can begin.
    Step B must be finished before step E can begin.
    Step D must be finished before step E can begin.
    Step F must be finished before step E can begin.

    Visually, these requirements look like this:

    ```
    -->A--->B--
    /    \      \
    C      -->D----->E
    \           /
    ---->F-----
    ```

    Your first goal is to determine the order in which the steps should be completed. If more than one step is ready, choose the step which is first alphabetically. In this example, the steps would be completed as follows:

    Only C is available, and so it is done first.
    Next, both A and F are available. A is first alphabetically, so it is done next.
    Then, even though F was available earlier, steps B and D are now also available, and B is the first alphabetically of the three.
    After that, only D and F are available. E is not available because only some of its prerequisites are complete. Therefore, D is completed next.
    F is the only choice, so it is done next.
    Finally, E is completed.

    So, in this example, the correct order is CABDFE.

    In what order should the steps in your instructions be completed?
    """
    @step_regex ~r/step ([a-z])+ must .+ step ([a-z])+ can/i

    def solve(input) do
      {steps, dependents, dependencies} =
        input
        |> Enum.reduce({%{}, %MapSet{}, %MapSet{}}, &reduce_steps/2)

      top_level_dependencies =
        dependencies
        |> MapSet.difference(dependents)
        |> Enum.reduce(%{}, &Map.put(&2, &1, %MapSet{}))

      run_steps(Map.merge(steps, top_level_dependencies))
    end

    def reduce_steps(line, {steps, dependents, dependencies}) do
      with [_, dependency, dependent] <- Regex.run(@step_regex, line),
           steps <-
             steps
             |> Map.update(dependent, MapSet.new([dependency]), &MapSet.put(&1, dependency)),
           dependents <- dependents |> MapSet.put(dependent),
           dependencies <- dependencies |> MapSet.put(dependency) do
        {steps, dependents, dependencies}
      end
    end

    def run_steps(steps), do: run_steps(steps, [])

    def run_steps(steps, steps_run) do
      next_step =
        get_available_steps(steps, steps_run)
        |> List.first()

      steps_run = [next_step | steps_run]
      steps = steps |> Map.delete(next_step)

      case Map.size(steps) do
        0 -> steps_run |> Enum.reverse() |> Enum.join()
        _ -> run_steps(steps, steps_run)
      end
    end

    def get_available_steps(steps, steps_run) do
      steps_run_set = MapSet.new(steps_run)

      steps
      |> Enum.flat_map(fn {key, value} ->
        if MapSet.subset?(value, steps_run_set), do: [key], else: []
      end)
      |> Enum.sort()
      |> Enum.dedup()
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
