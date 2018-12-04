defmodule Mix.Tasks.NewDay do
  use Mix.Task

  def run([day]) do
    day = to_string(day) |> String.pad_leading(2, "0")
    data = [day: day]

    render_template("lib/mix/tasks/new_day_template.eex", "lib/aoc_2018/day_#{day}.ex", data)

    render_template(
      "lib/mix/tasks/new_day_test_template.eex",
      "test/aoc_2018/day_#{day}_test.exs",
      data
    )

    Mix.shell().info("Generated module and test files for day \"#{day}\"")
  end

  def run([]) do
    Mix.shell().error("No day provided.")
  end

  def render_template(input_path, output_path, data) do
    if File.exists?(output_path), do: raise("Module \"#{output_path}\" exists.")
    template = EEx.eval_file(input_path, data)
    File.write!(output_path, template)
  end
end
