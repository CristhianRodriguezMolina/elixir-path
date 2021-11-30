# QUOTE ------------------------------------------

IO.puts("QUOTE:")

# Tuples of the quote format: {atom | tuple, list, list | atom}

IO.inspect(quote do: String.upcase("foo"))

# This two below are equals
IO.inspect(quote do: if(true, do: :this, else: :that))

IO.inspect(
  quote do:
          (if true do
             :this
           else
             :that
           end)
)

# Reverting a quote

IO.puts("Reverting a quote: #{Macro.to_string(quote do: sum(1, 2 + 3, 4))}")

# UNQUOTE --------------------------------

IO.puts("\nUNQUOTE:")

number = 13

# To get the representation with the value of number and not with the variable itself ("11 + number")
IO.puts(Macro.to_string(quote do: 11 + unquote(number)))

fun = :hello

IO.puts(Macro.to_string(quote do: unquote(fun)(:world)))

# Inserting a list in other list

# [1, 2, [3, 4, 5], 6]
IO.puts(Macro.to_string(quote do: [1, 2, unquote([3, 4, 5]), 6]))

# [1, 2, 3, 4, 5, 6]
IO.puts(Macro.to_string(quote do: [1, 2, unquote_splicing([3, 4, 5]), 6]))

# ESCAPING

IO.inspect(quote do: %{hello: :world})

IO.inspect(Macro.escape(%{hello: :world}))

# MACROS ---------------------------------------------

IO.puts("\nMACROS:")

require Unless

# This cant be used cause its a macro in the same context
IO.inspect(Unless.unless_macro(true, do: IO.puts("This is not showing up")))

# This shows the answer cause the functions are evaluated before the call
IO.inspect(Unless.unless_fun(true, do: IO.puts("This is not showing up")))

# Hygiene
require HygieneTest

HygieneTest.go()

# Sample test
require Sample

IO.puts(Sample.multi())

# __ENV__ test
IO.inspect(__ENV__.requires)
IO.inspect(__ENV__.file)

# Var

IO.inspect(Sample.run())

var = Macro.var(:red, nil)

IO.inspect(var)

IO.inspect(quote do: unquote(var) = unquote(3))

# DSL -------------------------------------

IO.puts("\nDSL:")

# Retrieving information from a module
IO.inspect(Sample.__info__(:functions))
IO.inspect(Sample.__info__(:macros))

# Testing a test module (DSL)

defmodule UsingTestCase do
  use TestCase

  test "New test" do
    5 = 4 + 1
  end

  test "New test with map" do
    %{a: 1, b: 3} = Map.put(%{a: 1}, :b, 3)
  end

  # This will throw an error
  test "New test with list" do
    [1, 2, 3] = [1, 2] ++ [4]
  end
end

UsingTestCase.run()
