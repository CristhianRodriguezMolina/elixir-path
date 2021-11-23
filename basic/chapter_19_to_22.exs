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
  # Defining a custom type called num that is of type integer
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
  # This raise an error cause the parse function does not have any arguments
  # def parse, do: {:ok, "something bad"}
  def parse(_str), do: {:ok, "something bad"}

  @impl Parser
  def extensions, do: ["bad"]
end

IO.inspect(BADParser.extensions())
