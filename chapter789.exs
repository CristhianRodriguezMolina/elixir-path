# Keyword lists and maps -----------------------------

IO.puts("\nKeyword lists and maps")

keywordlist = [a: 1, b: 2, a: 3]

IO.puts("Keyword list: #{inspect(keywordlist)}")

IO.puts("Keyword list at a: #{keywordlist[:a]}")

[a: x, b: y, a: z] = keywordlist

IO.puts(inspect([x, y, z]))

# Maps

IO.puts("\nMaps")

map1 = %{a: 1, b: 2, c: 3}
map2 = %{1 => 1, 2 => 2, 3 => 3}

IO.puts(inspect(map1))
IO.puts("Map1 in a: #{map1[:a]}")

IO.puts(inspect(map2))
IO.puts("Map2 in 2: #{map2[2]}")
IO.puts("Map2 in 4: #{inspect(map2[4])}")

# This does not give errors
%{} = %{:a => 1, 2 => :b}

# This match because the :a exists in both maps
%{:a => a} = %{:a => 1, 2 => :b}
IO.puts(a)

n = 1

%{^n => :one} = %{1 => :one, 2 => :two, 3 => :three}
# %{^n => :one} = %{2 => :one, 2 => :two, 3 => :three} # Error in the right side

# There is no problem in a map with more than a equal key
map3 = %{:a => 45, :b => :b}

# Needs to be rebound cause it is inmutable
map3 = Map.put(map3, :c, 50)

IO.puts(inspect(%{map3 | :a => map3[:a] + 1}))

IO.puts("Accesing atom key map3.a -> #{map3.a}")

users = [
  john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
  mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
]

# put_in/2 method, changind John's age
users = put_in(users[:john].age, 25)

IO.puts(inspect(users))

# update_in/2 method, deleting Clojure from Mary's lenguages
users = update_in(users[:mary].languages, fn languages -> List.delete(languages, "Clojure") end)

IO.puts(inspect(users))

# Adding a newdata field in John's data
users = Keyword.replace(users, :john, Map.put(users[:john], :newdata, "New data"))

IO.puts(inspect(users))

# Modules and functions -----------------------------

IO.puts("\nModules and functions")

defmodule Math do
  # Function that can be used from other modules
  def sum(a, b) do
    do_sum(a, b)
  end

  # Function just used locally
  defp do_sum(a, b) do
    a + b
  end
end

IO.puts("Using the Math defmodule to add 56 and 45: #{Math.sum(56, 45)}")

defmodule Math2 do
  # The "?" means that this function returns a boolean
  def zero?(0) do
    true
  end

  # Enters just when the "when" is true
  def zero?(x) when is_integer(x) do
    false
  end
end

# Capture operator

# The &1 its the first argument passed
fun = &(&1 + &2)

IO.puts(fun.(3, 4))

# Capturing the is_function/1 function
IO.puts((&is_function/1).(fun))

defmodule Concat do
  # \\ for default argument
  def join(a, b, sep \\ ", "), do: a <> sep <> b
end

IO.puts(Concat.join("Hi", "babe"))
IO.puts(Concat.join("Hi", "babe", " "))

defmodule Concat2 do
  def join(a, b) do
    IO.puts("***First join")
    a <> b
  end

  # If sep is a default argument elixir will gave us a warning "this clause cannot match because a previous clause"
  def join(a, b, sep) do
    IO.puts("***Second join")
    a <> sep <> b
  end
end

IO.puts(Concat2.join("a", "b", ""))

# Recursion

IO.puts("\nRecursion")

# This instead of for and while loops
defmodule Recursion do
  # Loop of the recursion
  def print_multiple_times(msg, n) when n > 0 do
    IO.puts(msg)
    print_multiple_times(msg, n - 1)
  end

  # Stopping case
  def print_multiple_times(_msg, 0) do
    :ok
  end
end

IO.puts("Printing something n times:")
IO.puts(Recursion.print_multiple_times("This is something", 4))

IO.puts("\nREDUCING:")

defmodule MathReduce do
  # Enters here firtly due to the matching rules, i.e. [head | tail] = [1, 2, 3]
  def sum_list([head | tail], accumulator) do
    sum_list(tail, head + accumulator)
  end

  # Stopping case when the list passed is equal to [] empty
  def sum_list([], accumulator) do
    accumulator
  end
end

IO.puts("Sum of #{inspect([1, 2, 34, 5])}: #{MathReduce.sum_list([1, 2, 34, 5], 0)}")
# With Enum
IO.puts(Enum.reduce([1, 2, 3], 0, fn x, acc -> x + acc end))
IO.puts("Starts with acc = 5: " <> to_string(Enum.reduce([1, 2, 3], 5, &+/2)))
IO.puts("Starts with acc = 0: " <> to_string(Enum.reduce([1, 2, 3], &+/2)))

IO.puts("\nMAPPING:")

defmodule MathMapping do
  def double_each([head | tail]) do
    [head * 2 | double_each(tail)]
  end

  def double_each([]) do
    []
  end
end

IO.puts(
  "Doubling each of #{inspect([1, 2, 34, 5])}: #{inspect(MathMapping.double_each([1, 2, 34, 5]))}"
)

# With Enum
IO.puts(inspect(Enum.map([1, 2, 3], fn x -> x * 2 end)))
IO.puts(inspect(Enum.map([1, 2, 3], &(&1 * 2))))
