defmodule Mix.Tasks.Solve do
  use Mix.Task
  import Benchmark

  def run([day, part]) do
    day = to_string(day) |> String.pad_leading(2, "0")
    part = to_string(part)

    result =
      with_input(day, fn input ->
        module =
          "Elixir.Day#{day}.Part#{part}"
          |> String.to_existing_atom()

        case System.get_env("MEASURE") do
          nil -> apply(module, :solve, [input])
          _ -> measure(apply(module, :solve, [input]))
        end
      end)

    Mix.shell().info("Day #{day}, Part #{part}: #{result}")
  end

  def run([day]) do
    Enum.each([1, 2], &run([day, &1]))
  end

  def run([]) do
    Enum.each(1..25, &run([&1]))
  end

  defp with_input(day, fun) do
    Aoc2018.input(day)
    |> fun.()
  rescue
    File.Error -> "No Input"
  end
end
