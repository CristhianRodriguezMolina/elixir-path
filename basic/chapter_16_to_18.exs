# Protocols ------------------------------

IO.puts("\nPROTOCOLS")

# First type of polymorphism
defmodule Utility do
  def type(value) when is_binary(value), do: "string"
  def type(value) when is_integer(value), do: "integer"
  # ... other implementations ...
end

# FIRST SIZE PROTOCOL WITHOUT @fallback_to_any
defprotocol Size do
  @doc "Calculates the size (and not the length!) of a data structure"
  def size(data)
end

defimpl Size, for: BitString do
  def size(string), do: byte_size(string)
end

defimpl Size, for: Map do
  def size(map), do: map_size(map)
end

defimpl Size, for: Tuple do
  def size(tuple), do: tuple_size(tuple)
end

# This does not work and raise an error without the defprotocol above ---
defimpl Size, for: Any do
  def size(_), do: 2
end

# SECOND PROTOCOL WITH @fallback_to_any
defprotocol Size2 do
  @doc "Calculates the size (and not the length!) of a data structure"

  # With this this any fall to the implementation of any in every protocol
  @fallback_to_any true
  def size(data)
end

defimpl Size2, for: Any do
  def size(_), do: 5
end

# test strucs ---
# WITHOUT @derive
defmodule User do
  defstruct [:name, :age]
end

# WITH @derive
defmodule OtherUser do
  # with this just fall to any in the Size protocol
  @derive [Size]
  defstruct [:name, :age]
end

# Built-in protocols

IO.inspect(Enum.map([1, 2, 3, 4, 5], fn x -> x * x end))
IO.puts(Enum.reduce(1..100, fn x, acc -> x * acc end))

# This prints something like "#Function......"
# The "#" at the start means that is not reversible as information
IO.inspect(&(&1 * 2))

# Comprehensions ------------------------------------------------

IO.puts("\nCOMPREHENSIONS")

IO.inspect(for n <- 1..56, do: n + n)

# Generators

# I the expresion n <- 1..56 is the generator

# Conditions
IO.inspect(for n <- [1, 5, 8, 4, 2, -1, 6], n > 4, do: n)

IO.inspect(for {:good, n} <- [good: 1, bad: 5, good: 9], n > 4, do: to_string(n))

IO.inspect([{:good, 4}, {:good, 4}])

# Scanning directories
dirs = ['.']

files =
  for dir <- dirs,
      file <- File.ls!(dir),
      path = Path.join(dir, file),
      File.regular?(path) do
    file
  end

# Printing the files in the current folder
IO.inspect(files)

# Cartesian product with two generators
IO.puts(
  "Cartesian product between [:a, :b, :c] and [1, 2]: #{inspect(for i <- [:a, :b, :c], j <- [1, 2], do: {i, j})}"
)

pixels = <<213, 45, 132, 64, 76, 32, 76, 0, 0, 234, 32, 15>>

# Cause the enum is not implemented for Bitstring you sould do <<r::8, g::8, b::8 <- pixels>> for generators
IO.inspect(for <<r::8, g::8, b::8 <- pixels>>, do: {r, g, b})

# :into option in comprehension

IO.puts(":into option in comprehension: ")

IO.inspect(for <<c <- " hello world ">>, c != ?\s, into: %{}, do: {<<c>>, <<c>>})
IO.inspect(for <<c <- " hello world ">>, c != ?\s, into: "", do: <<c>>)

# stream = IO.stream(:stdio, :line)

# for line <- stream, into: stream do
#   String.upcase(line) <> "\n"
# end

IO.puts(":unique option in comprehension: ")

IO.inspect(for n <- [1, 1, 1, 5, 5, 2, 2], uniq: true, do: n)

IO.puts(":reduce option in comprehension: ")

# This counts the amount of lowercase letters in a string and create a map whit that
lowerCaseCount =
  for <<x <- "AbCabCABc">>, x in ?a..?z, reduce: %{} do
    acc -> Map.update(acc, <<x>>, 1, &(&1 + 1))
  end

IO.inspect(lowerCaseCount)

# Sigils ------------------------------------------------

IO.puts("\nREGULAR EXPRESSIONS")

IO.puts("Wordlist: #{inspect(~w(hello world baby))}")
IO.puts("Charlist: #{inspect(~c(hello world baby))}")
IO.puts("Atomlist: #{inspect(~w(hello world baby)a)}")

IO.puts("Creating a string: #{inspect(~s(String "double" quotes not 'single' quotes))}")
IO.puts("Creating a charlist: #{inspect(~c(String "double" quotes not 'single' quotes))}")

d = ~D[2000-05-26]

IO.puts("Birthday day: #{d.day}, and birthday: #{d}")

t = ~T[11:00:15]

IO.puts("Birthday hour: #{t}")

ndt = ~N[2019-10-31 23:00:07]

IO.puts("Another birthday: #{ndt.day}-#{ndt.month}-#{ndt.year}")

# Custom sigil
import MySigils

# Normal
IO.puts(~d(5))
# Double
IO.puts(~d(5)d)
# Triple
IO.puts(~d(5)t)
# Quatruple
IO.puts(~d(5)c)
