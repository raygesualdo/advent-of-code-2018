defmodule Benchmark do
  defmacro measure(pipe, ast) do
    quote do
      pipe = unquote(pipe)

      Benchmark.time_function("|> " <> unquote(Macro.to_string(ast)), fn ->
        pipe |> unquote(ast)
      end)
    end
  end

  defmacro measure(ast) do
    quote do
      Benchmark.time_function(unquote(Macro.to_string(ast)), fn -> unquote(ast) end)
    end
  end

  def time_function(label, fun) do
    {time, result} = :timer.tc(fun)
    IO.puts("#{label}: #{:erlang.convert_time_unit(time, :microsecond, :millisecond)}")
    result
  end
end
