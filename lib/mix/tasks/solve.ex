defmodule Mix.Tasks.Solve do
  use Mix.Task

  def run([day, part]) do
    day = to_string(day) |> String.pad_leading(2, "0")
    part = to_string(part)

    result =
      with_input(day, fn input ->
        "Elixir.Day#{day}.Part#{part}"
        |> String.to_existing_atom()
        |> apply(:solve, [input])
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
