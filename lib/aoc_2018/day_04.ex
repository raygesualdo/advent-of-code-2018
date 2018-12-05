defmodule Day04 do
  defmodule Part1 do
    @moduledoc """
    You've sneaked into another supply closet - this time, it's across from the prototype suit manufacturing lab. You need to sneak inside and fix the issues with the suit, but there's a guard stationed outside the lab, so this is as close as you can safely get.

    As you search the closet for anything that might help, you discover that you're not the first person to want to sneak in. Covering the walls, someone has spent an hour starting every midnight for the past few months secretly observing this guard post! They've been writing down the ID of the one guard on duty that night - the Elves seem to have decided that one guard was enough for the overnight shift - as well as when they fall asleep or wake up while at their post (your puzzle input).

    For example, consider the following records, which have already been organized into chronological order:

    ```
    [1518-11-01 00:00] Guard #10 begins shift
    [1518-11-01 00:05] falls asleep
    [1518-11-01 00:25] wakes up
    [1518-11-01 00:30] falls asleep
    [1518-11-01 00:55] wakes up
    [1518-11-01 23:58] Guard #99 begins shift
    [1518-11-02 00:40] falls asleep
    [1518-11-02 00:50] wakes up
    [1518-11-03 00:05] Guard #10 begins shift
    [1518-11-03 00:24] falls asleep
    [1518-11-03 00:29] wakes up
    [1518-11-04 00:02] Guard #99 begins shift
    [1518-11-04 00:36] falls asleep
    [1518-11-04 00:46] wakes up
    [1518-11-05 00:03] Guard #99 begins shift
    [1518-11-05 00:45] falls asleep
    [1518-11-05 00:55] wakes up
    ```

    Timestamps are written using year-month-day hour:minute format. The guard falling asleep or waking up is always the one whose shift most recently started. Because all asleep/awake times are during the midnight hour (00:00 - 00:59), only the minute portion (00 - 59) is relevant for those events.

    Visually, these records show that the guards are asleep at these times:

    ```
    Date   ID   Minute
                000000000011111111112222222222333333333344444444445555555555
                012345678901234567890123456789012345678901234567890123456789
    11-01  #10  .....####################.....#########################.....
    11-02  #99  ........................................##########..........
    11-03  #10  ........................#####...............................
    11-04  #99  ....................................##########..............
    11-05  #99  .............................................##########.....
    ```
    The columns are Date, which shows the month-day portion of the relevant day; ID, which shows the guard on duty that day; and Minute, which shows the minutes during which the guard was asleep within the midnight hour. (The Minute column's header shows the minute's ten's digit in the first row and the one's digit in the second row.) Awake is shown as ., and asleep is shown as #.

    Note that guards count as asleep on the minute they fall asleep, and they count as awake on the minute they wake up. For example, because Guard #10 wakes up at 00:25 on 1518-11-01, minute 25 is marked as awake.

    If you can figure out the guard most likely to be asleep at a specific time, you might be able to trick that guard into working tonight so you can have the best chance of sneaking in. You have two strategies for choosing the best guard/minute combination.

    Strategy 1: Find the guard that has the most minutes asleep. What minute does that guard spend asleep the most?

    In the example above, Guard #10 spent the most minutes asleep, a total of 50 minutes (20+25+5), while Guard #99 only slept for a total of 30 minutes (10+10+10). Guard #10 was asleep most during minute 24 (on two days, whereas any other minute the guard was asleep was only seen on one day).

    While this example listed the entries in chronological order, your entries are in the order you found them. You'll need to organize them before they can be analyzed.

    What is the ID of the guard you chose multiplied by the minute you chose? (In the above example, the answer would be 10 * 24 = 240.)
    """

    @start_shift_regex ~r/(?<h>\d{2}):(?<m>\d{2})\] guard #(?<id>\d+) begins/i
    @time_regex ~r/\[\d{4}-\d{2}-\d{2} (?<h>\d{2}):(?<m>\d{2})\]/
    # @start_sleep_regex ~r/(?<h>\d{2}):(?<m>\d{2})\] falls asleep/
    # @stop_sleep_regex ~r/(?<h>\d{2}):(?<m>\d{2})\] wakes up/

    def solve(input) do
      guard =
        input
        |> Enum.sort()
        |> Enum.chunk_by(&Regex.match?(@start_shift_regex, &1))
        |> Enum.chunk_every(2)
        |> Enum.map(&Enum.concat/1)
        # |> Enum.chunk_while([], &chunk_fun/2, &after_fun/1)
        |> Enum.map(&parse_chunk/1)
        |> Enum.sort_by(&Map.get(&1, "id"))
        |> Enum.chunk_by(&Map.get(&1, "id"))
        |> Enum.map(&merge_shifts/1)
        |> Enum.map(&ranges_to_sets/1)
        |> Enum.map(fn shift ->
          sum = shift |> Map.get("ranges") |> Enum.map(&MapSet.size/1) |> Enum.sum()
          Map.put(shift, "sum", sum)
        end)
        |> Enum.map(fn shift ->
          most_minute =
            shift
            |> Map.get("ranges")
            |> Enum.map(&MapSet.to_list/1)
            |> Enum.reduce(&Enum.concat/2)
            |> Enum.sort()
            |> Enum.chunk_by(& &1)
            |> Enum.sort_by(&length/1, &>=/2)
            |> List.first()
            |> List.first()

          Map.put(shift, "most_minute", most_minute)
        end)
        |> Enum.sort_by(&Map.get(&1, "sum"), &>=/2)
        |> List.first()

      guard["id"] * guard["most_minute"]
    end

    def parse_chunk([head | tail]) do
      id =
        Regex.named_captures(@start_shift_regex, head)
        |> Map.get("id")
        |> String.to_integer()

      parsed_ranges = parse_ranges(tail)
      %{"id" => id, "ranges" => parsed_ranges}
    end

    def parse_ranges(ranges) do
      ranges
      |> Enum.chunk_every(2)
      |> Enum.map(fn start_stop ->
        case List.to_tuple(start_stop) do
          {start, stop} -> {get_start_minute(start), get_start_minute(stop) - 1}
          {start} -> {get_start_minute(start), 59}
        end
      end)
    end

    def get_start_minute(timestamp) do
      Regex.named_captures(@time_regex, timestamp)
      |> Map.get("m")
      |> String.to_integer()
    end

    def merge_shifts(list) do
      list
      |> Enum.reduce(fn x, acc ->
        Map.merge(acc, x, fn key, v1, v2 ->
          case key do
            "ranges" -> Enum.concat(v1, v2)
            _ -> v1
          end
        end)
      end)
    end

    def ranges_to_sets(shift) do
      shift
      |> Map.update!("ranges", fn ranges ->
        Enum.map(ranges, fn {start, stop} ->
          MapSet.new(start..stop)
        end)
      end)
    end

    # def chunk_fun(item, acc) do
    #   # {item, acc} |> IO.inspect()

    #   if Regex.match?(@start_shift_regex, item) do
    #     {:cont, Enum.reverse([item | acc]), []}
    #   else
    #     {:cont, [item | acc]}
    #   end
    # end

    # def after_fun(acc) do
    #   case acc do
    #     [] -> {:cont, []}
    #     _ -> {:cont, acc, []}
    #   end
    # end

    # defmodule Guard do
    #   defstruct [:id, :sleep_ranges]

    #   def new(list) do
    #   end
    # end
  end

  defmodule Part2 do
    @moduledoc """
    Strategy 2: Of all guards, which guard is most frequently asleep on the same minute?

    In the example above, Guard #99 spent minute 45 asleep more than any other guard or minute - three times in total. (In all other cases, any guard spent any minute asleep at most twice.)

    What is the ID of the guard you chose multiplied by the minute you chose? (In the above example, the answer would be 99 * 45 = 4455.)
    """

    @start_shift_regex ~r/(?<h>\d{2}):(?<m>\d{2})\] guard #(?<id>\d+) begins/i
    @time_regex ~r/\[\d{4}-\d{2}-\d{2} (?<h>\d{2}):(?<m>\d{2})\]/
    # @start_sleep_regex ~r/(?<h>\d{2}):(?<m>\d{2})\] falls asleep/
    # @stop_sleep_regex ~r/(?<h>\d{2}):(?<m>\d{2})\] wakes up/

    def solve(input) do
      guard =
        input
        |> Enum.sort()
        |> Enum.chunk_by(&Regex.match?(@start_shift_regex, &1))
        |> Enum.chunk_every(2)
        |> Enum.map(&Enum.concat/1)
        # |> Enum.chunk_while([], &chunk_fun/2, &after_fun/1)
        |> Enum.map(&parse_chunk/1)
        |> Enum.sort_by(&Map.get(&1, "id"))
        |> Enum.chunk_by(&Map.get(&1, "id"))
        |> Enum.map(&merge_shifts/1)
        |> Enum.map(&ranges_to_sets/1)
        |> Enum.map(fn shift ->
          sum = shift |> Map.get("ranges") |> Enum.map(&MapSet.size/1) |> Enum.sum()
          Map.put(shift, "sum", sum)
        end)
        |> Enum.map(fn shift ->
          most_minutes =
            shift
            |> Map.get("ranges")
            |> Enum.map(&MapSet.to_list/1)
            |> Enum.reduce(&Enum.concat/2)
            |> Enum.sort()
            |> Enum.chunk_by(& &1)
            |> Enum.sort_by(&length/1, &>=/2)
            |> List.first()

          most_minute =
            most_minutes
            |> List.first()

          minute_frequency =
            most_minutes
            |> length

          shift
          |> Map.put("minute_frequency", minute_frequency)
          |> Map.put("most_minute", most_minute)
        end)
        |> Enum.sort_by(&Map.get(&1, "minute_frequency"), &>=/2)
        |> List.first()

      guard["id"] * guard["most_minute"]
    end

    def parse_chunk([head | tail]) do
      id =
        Regex.named_captures(@start_shift_regex, head)
        |> Map.get("id")
        |> String.to_integer()

      parsed_ranges = parse_ranges(tail)
      %{"id" => id, "ranges" => parsed_ranges}
    end

    def parse_ranges(ranges) do
      ranges
      |> Enum.chunk_every(2)
      |> Enum.map(fn start_stop ->
        case List.to_tuple(start_stop) do
          {start, stop} -> {get_start_minute(start), get_start_minute(stop) - 1}
          {start} -> {get_start_minute(start), 59}
        end
      end)
    end

    def get_start_minute(timestamp) do
      Regex.named_captures(@time_regex, timestamp)
      |> Map.get("m")
      |> String.to_integer()
    end

    def merge_shifts(list) do
      list
      |> Enum.reduce(fn x, acc ->
        Map.merge(acc, x, fn key, v1, v2 ->
          case key do
            "ranges" -> Enum.concat(v1, v2)
            _ -> v1
          end
        end)
      end)
    end

    def ranges_to_sets(shift) do
      shift
      |> Map.update!("ranges", fn ranges ->
        Enum.map(ranges, fn {start, stop} ->
          MapSet.new(start..stop)
        end)
      end)
    end
  end
end
