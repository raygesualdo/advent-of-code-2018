defmodule Day16 do
  defmodule Ops do
    import Bitwise

    def addr(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, elem(register, iA) + elem(register, iB))

    def addi(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, elem(register, iA) + iB)

    def mulr(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, elem(register, iA) * elem(register, iB))

    def muli(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, elem(register, iA) * iB)

    def banr(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, elem(register, iA) &&& elem(register, iB))

    def bani(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, elem(register, iA) &&& iB)

    def borr(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, elem(register, iA) ||| elem(register, iB))

    def bori(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, elem(register, iA) ||| iB)

    def setr(register, {_, iA, _, iC}), do: put_elem(register, iC, elem(register, iA))
    def seti(register, {_, iA, _, iC}), do: put_elem(register, iC, iA)

    def gtir(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, gt(iA, elem(register, iB)))

    def gtri(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, gt(elem(register, iA), iB))

    def gtrr(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, gt(elem(register, iA), elem(register, iB)))

    def eqir(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, eq(iA, elem(register, iB)))

    def eqri(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, eq(elem(register, iA), iB))

    def eqrr(register, {_, iA, iB, iC}),
      do: put_elem(register, iC, eq(elem(register, iA), elem(register, iB)))

    defp gt(a, b) do
      if a > b, do: 1, else: 0
    end

    defp eq(a, b) do
      if a == b, do: 1, else: 0
    end
  end

  defmodule Part1 do
    @moduledoc """
    As you see the Elves defend their hot chocolate successfully, you go back to falling through time. This is going to become a problem.

    If you're ever going to return to your own time, you need to understand how this device on your wrist works. You have a little while before you reach your next destination, and with a bit of trial and error, you manage to pull up a programming manual on the device's tiny screen.

    According to the manual, the device has four registers (numbered 0 through 3) that can be manipulated by instructions containing one of 16 opcodes. The registers start with the value 0.

    Every instruction consists of four values: an opcode, two inputs (named A and B), and an output (named C), in that order. The opcode specifies the behavior of the instruction and how the inputs are interpreted. The output, C, is always treated as a register.

    In the opcode descriptions below, if something says "value A", it means to take the number given as A literally. (This is also called an "immediate" value.) If something says "register A", it means to use the number given as A to read from (or write to) the register with that number. So, if the opcode addi adds register A and value B, storing the result in register C, and the instruction addi 0 7 3 is encountered, it would add 7 to the value contained by register 0 and store the sum in register 3, never modifying registers 0, 1, or 2 in the process.

    Many opcodes are similar except for how they interpret their arguments. The opcodes fall into seven general categories:

    Addition:

    - `addr` (add register) stores into register C the result of adding register A and register B.
    - `addi` (add immediate) stores into register C the result of adding register A and value B.

    Multiplication:

    - `mulr` (multiply register) stores into register C the result of multiplying register A and register B.
    - `muli` (multiply immediate) stores into register C the result of multiplying register A and value B.

    Bitwise AND:

    - `banr` (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
    - `bani` (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.

    Bitwise OR:

    - `borr` (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
    - `bori` (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.

    Assignment:

    - `setr` (set register) copies the contents of register A into register C. (Input B is ignored.)
    - `seti` (set immediate) stores value A into register C. (Input B is ignored.)

    Greater-than testing:

    - `gtir` (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
    - `gtri` (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
    - `gtrr` (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.

    Equality testing:

    - `eqir` (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
    - `eqri` (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
    - `eqrr` (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.

    Unfortunately, while the manual gives the name of each opcode, it doesn't seem to indicate the number. However, you can monitor the CPU to see the contents of the registers before and after instructions are executed to try to work them out. Each opcode has a number from 0 through 15, but the manual doesn't say which is which. For example, suppose you capture the following sample:

    ```
    Before: [3, 2, 1, 1]
    9 2 1 2
    After:  [3, 2, 2, 1]
    ```

    This sample shows the effect of the instruction 9 2 1 2 on the registers. Before the instruction is executed, register 0 has value 3, register 1 has value 2, and registers 2 and 3 have value 1. After the instruction is executed, register 2's value becomes 2.

    The instruction itself, 9 2 1 2, means that opcode 9 was executed with A=2, B=1, and C=2. Opcode 9 could be any of the 16 opcodes listed above, but only three of them behave in a way that would cause the result shown in the sample:

    Opcode 9 could be mulr: register 2 (which has a value of 1) times register 1 (which has a value of 2) produces 2, which matches the value stored in the output register, register 2.
    Opcode 9 could be addi: register 2 (which has a value of 1) plus value 1 produces 2, which matches the value stored in the output register, register 2.
    Opcode 9 could be seti: value 2 matches the value stored in the output register, register 2; the number given for B is irrelevant.

    None of the other opcodes produce the result captured in the sample. Because of this, the sample above behaves like three opcodes.

    You collect many of these samples (the first section of your puzzle input). The manual also includes a small test program (the second section of your puzzle input) - you can ignore it for now.

    Ignoring the opcode numbers, how many samples in your puzzle input behave like three or more opcodes?
    """
    @operations elem(Enum.unzip(Ops.__info__(:functions)), 0)
    @values_regex ~r/(\d+),? (\d+),? (\d+),? (\d+)/

    def solve(input) do
      input
      |> Enum.split_while(fn v -> v != "--------------------" end)
      |> elem(0)
      |> Enum.chunk_every(3)
      |> Enum.map(&parse_operation_group/1)
      |> Enum.map(&find_possible_matches/1)
      |> Enum.reject(fn set -> MapSet.size(set) < 3 end)
      |> length()
    end

    def parse_operation_group([bef, op, aft]) do
      {
        string_to_instructions(bef),
        string_to_instructions(op),
        string_to_instructions(aft)
      }
    end

    def string_to_instructions(string),
      do:
        Regex.run(@values_regex, string, capture: :all_but_first)
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()

    def find_possible_matches({bef, op, aft}) do
      @operations
      |> Enum.reduce(%MapSet{}, fn fun, matches ->
        if apply(Ops, fun, [bef, op]) == aft, do: MapSet.put(matches, fun), else: matches
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Using the samples you collected, work out the number of each opcode and execute the test program (the second section of your puzzle input).

    What value is contained in register 0 after executing the test program?
    """
    alias Day16.Part1

    def solve(input) do
      {operation_groups, program} =
        input
        |> Enum.split_while(fn v -> v != "--------------------" end)

      op_codes =
        operation_groups
        |> Enum.chunk_every(3)
        |> Enum.map(&Part1.parse_operation_group/1)
        |> determine_ops()

      run_program(program, op_codes)
      |> Tuple.to_list()
      |> List.first()
    end

    def determine_ops(operations_groups) do
      {known_ops, unknown_ops} =
        operations_groups
        |> Enum.reduce(%{}, &find_possible_matches/2)
        |> split_known_operations()

      determine_ops(known_ops, unknown_ops)
    end

    def determine_ops(known_ops, unknown_ops) when map_size(unknown_ops) == 0 do
      known_ops
      |> Enum.map(fn {key, set} -> {key, List.first(MapSet.to_list(set))} end)
      |> Enum.into(%{})
    end

    def determine_ops(known_ops, unknown_ops) do
      known_ops_set =
        known_ops
        |> Map.values()
        |> Enum.reduce(%MapSet{}, &MapSet.union/2)

      {additional_known_ops, unknown_ops} =
        unknown_ops
        |> Enum.map(fn {key, ops_set} -> {key, MapSet.difference(ops_set, known_ops_set)} end)
        |> Enum.into(%{})
        |> split_known_operations()

      known_ops = Map.merge(known_ops, additional_known_ops)

      determine_ops(known_ops, unknown_ops)
    end

    def find_possible_matches({_, op, _} = operation_group, match_map) do
      matches = Part1.find_possible_matches(operation_group)

      match_map |> Map.update(elem(op, 0), matches, fn set -> MapSet.union(set, matches) end)
    end

    def split_known_operations(operations) do
      {known_ops, unknown_ops} =
        operations |> Enum.split_with(fn {_, set} -> MapSet.size(set) == 1 end)

      {known_ops |> Map.new(), unknown_ops |> Map.new()}
    end

    def run_program(program, op_codes) do
      program
      |> Enum.drop(1)
      |> Enum.map(&Part1.string_to_instructions/1)
      |> Enum.reduce({0, 0, 0, 0}, fn {op_code, _, _, _} = op, bef ->
        fun = Map.get(op_codes, op_code)
        apply(Ops, fun, [bef, op])
      end)
    end
  end
end
