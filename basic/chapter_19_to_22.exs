# try, catch and rescue -------------------------

# Errors ------------------------------------

IO.puts("\nERRORS:")

defmodule SomeError do
  defexception message: "This is some error"
end

try do
  raise SomeError, "Custom message"
rescue
  e in SomeError -> IO.inspect(e)
  RuntimeError -> IO.puts("Runtime error")
end

file = File.read("chapter_1_to_3.exs")

{:ok, filecontent} = file

# IO.puts(filecontent)

# Reraise

require Logger

try do
  raise "oops"
rescue
  _ ->
    IO.puts(
      "This is a Logger to observability and monitoring so i have to comment it to continue with the flow of the file"
    )

    # Logger.error(Exception.format(:error, e, __STACKTRACE__))
    # reraise e, __STACKTRACE__
end

# Throws

IO.puts("\nTHROWS")

# This have only logic if there was no proper API in Enum
x =
  try do
    Enum.each(-50..50, fn x ->
      if rem(x, 13) == 0, do: throw(x)
    end)

    "Got nothing"
  catch
    x -> x
  end

IO.puts("First number divisible by 13 in range -50 to 50: #{x}")

# We can do what was done above like is shown below

IO.puts("Example with Enum.find: #{Enum.find(-50..50, &(rem(&1, 13) == 0))}")

IO.puts(
  try do
    exit("I am exiting")
  catch
    :exit, _ -> "not really"
  end
)

IO.puts("Something else")

# Else

IO.puts("\nELSE:")

x = 0

result =
  try do
    87 / x
  rescue
    ArithmeticError -> :infinity
  else
    # Enters here when the try clause doesnt finish with a throw or an error
    # If enters here the output of the try will be the input of the next clause
    z when z < 1 and z > -1 ->
      :small

    _ ->
      :large
  end

IO.puts(result)

# Typespecs and behaviours --------------------------------------

# Type specs

defmodule NewSpecModule do
  @typedoc """
    Any type of number like integer, float, etc.
  """
  # Defining a custom type called num that is of type number
  @type num :: number()

  # Custom private type
  @typep custom_struc :: %{message: String.t(), number: number()}

  # Defining a custom spec to function sum that receives two nums and returns an integer
  @spec sum_and_round(num, num) :: integer()
  def sum_and_round(num1, num2) do
    round(num1 + num2)
  end

  @spec multiply(num, num) :: custom_struc
  def multiply(num1, num2) do
    if(num1 > num2) do
      %{message: "num1 < num2", number: num1 * num2}
    else
      %{message: "num1 < num2", number: num1 * num2}
    end
  end
end

IO.inspect(NewSpecModule.multiply(6, 5))

#  Behaviours

IO.puts("\nBEHAVIOURS:")

defmodule Parser do
  @doc """
  Parses a string.
  """
  @callback parse(String.t()) :: {:ok, term} | {:error, String.t()}

  @doc """
  Lists all supported file extensions.
  """
  @callback extensions() :: [String.t()]

  # This method is to prove the implementations of this Parser behaviour
  def parse!(impl, contents) do
    require IEx
    IEx.pry()

    case impl.parse(contents) do
      {:ok, data} -> data
      {:error, error} -> raise ArgumentError, "Parsing error: #{error}"
    end
  end
end

# This is a good implementation of the Parser module
defmodule JSONParser do
  @behaviour Parser

  @impl Parser
  # ... parse JSON
  def parse(str), do: {:ok, "some json " <> str}

  @impl Parser
  def extensions, do: ["json"]
end

IO.inspect(JSONParser.parse("Hello"))

# Example of a bad parse
defmodule BADParser do
  @behaviour Parser

  @impl Parser
  # This shows a warning cause the parse function does not have any arguments
  def parse(), do: {:ok, "something bad"}

  @impl Parser
  def extensions, do: ["bad"]
end

IO.inspect(BADParser.parse())

# Erlang libraries ------------------------------------

IO.puts("\nERLANG LIBRARIES:")

# binary

IO.puts("\nbinary:")

IO.inspect(String.to_charlist("é"))
IO.inspect(:binary.bin_to_list("é"))

# ets

IO.puts("\nets:")

table = :ets.new(:ets_test, [])

# Store as tuples with {name, population}
:ets.insert(table, {"China", 1_374_000_000})

# IO.inspect(:ets.i(table))

# digraph

IO.puts("\ndigraph:")

digraph = :digraph.new()

coords = [{0.0, 0.0}, {1.0, 0.0}, {1.0, 1.0}, {0.0, 0.1}, {2.0, 0.0}, {0.0, 2.0}]

[v1, v2, v3, v4, v5, v6] = for c <- coords, do: :digraph.add_vertex(digraph, c)

# Adding edges keeping in mind the vertices
:digraph.add_edge(digraph, v1, v2)
:digraph.add_edge(digraph, v1, v5)
:digraph.add_edge(digraph, v3, v5)
:digraph.add_edge(digraph, v6, v5)
:digraph.add_edge(digraph, v5, v4)

IO.puts("Digraph: #{inspect(digraph)}")

# Path from 1 to 4
IO.puts("Path from v1 to v4: #{inspect(:digraph.get_short_path(digraph, v1, v4))}")
# Imposible path
IO.puts("Path from v1 to v4: #{inspect(:digraph.get_short_path(digraph, v1, v3))}")

# Queue

IO.puts("\nqueue:")

# Queue is a tuple with two values (lists) first list is the queue and the second is where the first in the queue is allocated
queue = :queue.new()

IO.puts("new queue: #{inspect(queue)}")

queue = :queue.in([1, 2, 3], queue)
queue = :queue.in(%{a: :b, b: :c}, queue)
queue = :queue.in(1, queue)
queue = :queue.in({1.456, 3.1416}, queue)

IO.puts("queue: #{inspect(queue)}")

{value, queue} = :queue.out(queue)

IO.puts("out: #{inspect(value)}, queue: #{inspect(queue)} ")

queue = :queue.in(elem(value, 1), queue)

IO.puts("in: #{inspect(value)}, queue: #{inspect(queue)} ")

# Rand

IO.puts("\nrand:")

# Float random
IO.puts(:rand.uniform())
IO.puts(:rand.uniform())
IO.puts(:rand.uniform())

# Integer random from 1 to the number argument
IO.puts(:rand.uniform(15))
IO.puts(:rand.uniform(10))
IO.puts(:rand.uniform(5))

# Custom seed
_ = :rand.seed(:exs1024, {222, 212_131, 21_535_533})

# Random with custom seed
IO.puts(:rand.uniform())
