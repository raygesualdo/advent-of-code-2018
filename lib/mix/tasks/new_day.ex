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

    write_file("data/day#{day}.txt", "")

    Mix.shell().info("Generated module, test, and data files for day \"#{day}\"")
  end

  def run([]) do
    Mix.shell().error("No day provided.")
  end

  def render_template(input_path, output_path, data) do
    template = EEx.eval_file(input_path, data)
    write_file(output_path, template)
  end

  def write_file(output_path, data) do
    if File.exists?(output_path), do: raise("Module \"#{output_path}\" exists.")
    File.write!(output_path, data)
  end
end
