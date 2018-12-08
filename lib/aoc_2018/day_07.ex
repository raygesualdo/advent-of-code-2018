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
      with steps_run_set <- MapSet.new(steps_run) do
        steps
        |> Enum.flat_map(fn {key, value} ->
          if MapSet.subset?(value, steps_run_set), do: [key], else: []
        end)
        |> Enum.sort()
        |> Enum.dedup()
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    As you're about to begin construction, four of the Elves offer to help. "The sun will set soon; it'll go faster if we work together." Now, you need to account for multiple people working on steps simultaneously. If multiple steps are available, workers should still begin them in alphabetical order.

    Each step takes 60 seconds plus an amount corresponding to its letter: A=1, B=2, C=3, and so on. So, step A takes 60+1=61 seconds, while step Z takes 60+26=86 seconds. No time is required between steps.

    To simplify things for the example, however, suppose you only have help from one Elf (a total of two workers) and that each step takes 60 fewer seconds (so that step A takes 1 second and step Z takes 26 seconds). Then, using the same instructions as above, this is how each second would be spent:

    ```
    Second   Worker 1   Worker 2   Done
    0        C          .
    1        C          .
    2        C          .
    3        A          F          C
    4        B          F          CA
    5        B          F          CA
    6        D          F          CAB
    7        D          F          CAB
    8        D          F          CAB
    9        D          .          CABF
    10       E          .          CABFD
    11       E          .          CABFD
    12       E          .          CABFD
    13       E          .          CABFD
    14       E          .          CABFD
    15       .          .          CABFDE
    ```

    Each row represents one second of time. The Second column identifies how many seconds have passed as of the beginning of that second. Each worker column shows the step that worker is currently doing (or . if they are idle). The Done column shows completed steps.

    Note that the order of the steps has changed; this is because steps now take time to finish and multiple workers can begin multiple steps simultaneously.

    In this example, it would take 15 seconds for two workers to complete these steps.

    With 5 workers and the 60+ second step durations described above, how long will it take to complete all of the steps?
    """

    @workers 5
    @duration_padding 60

    def solve(input) do
      {steps, dependents, dependencies} =
        input
        |> Enum.reduce({%{}, %MapSet{}, %MapSet{}}, &Part1.reduce_steps/2)

      top_level_dependencies =
        dependencies
        |> MapSet.difference(dependents)
        |> Enum.reduce(%{}, &Map.put(&2, &1, %MapSet{}))

      workers = create_workers(@workers)

      iterate_with_workers(workers, Map.merge(steps, top_level_dependencies), [], 0)
    end

    def create_workers(quantity) do
      for _ <- 1..quantity, do: {"", 0}
    end

    def iterate_with_workers(workers, steps, steps_run, iteration) do
      {workers, steps, steps_run} =
        workers
        |> Enum.reduce(
          {[], steps, steps_run},
          &run_worker/2
        )

      workers = workers |> Enum.sort_by(&elem(&1, 1), &>=/2)

      case Map.size(steps) do
        0 -> iteration
        _ -> iterate_with_workers(workers, steps, steps_run, iteration + 1)
      end
    end

    def run_worker({id, worker_iteration}, {workers, steps, steps_run})
        when worker_iteration > 1 do
      {[{id, worker_iteration - 1} | workers], steps, steps_run}
    end

    def run_worker({id, _}, {workers, steps, steps_run}) do
      {steps, steps_run} =
        case id do
          "" -> {steps, steps_run}
          _ -> stop_step(id, steps, steps_run)
        end

      if Enum.count(Part1.get_available_steps(steps, steps_run)) == 0 do
        {[{"", 0} | workers], steps, steps_run}
      else
        started_step =
          start_step(get_steps_in_progress(workers), Part1.get_available_steps(steps, steps_run))

        workers = [{started_step, duration_by_key(started_step)} | workers]

        {workers, steps, steps_run}
      end
    end

    def start_step(steps_in_progress, available_dependencies) do
      available_dependencies
      |> Enum.reject(&MapSet.member?(steps_in_progress, &1))
      |> Enum.sort()
      |> List.first()
      |> case do
        nil -> ""
        value -> value
      end
    end

    def stop_step(step, steps, steps_run) do
      steps = steps |> Map.delete(step)
      steps_run = [step | steps_run]

      {steps, steps_run}
    end

    def get_steps_in_progress(workers) do
      workers
      |> Enum.reduce(%MapSet{}, fn worker, set ->
        set |> MapSet.put(elem(worker, 0))
      end)
    end

    def duration_by_key(""), do: 0

    def duration_by_key(string) do
      (string |> String.to_charlist() |> List.first()) - ?A + 1 + @duration_padding
    end
  end
end
