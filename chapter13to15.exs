# alias, require and import

# To use integer we need to require it
require Integer

IO.inspect(Integer.is_odd(3))

# Import

defmodule Mod do
  def function do
    import List, only: [duplicate: 2]
    duplicate(:ok, 5)
  end

  # def function2 do
  #   duplicate(:bad, 5)
  # end
end

# Printing from Module.function/0
IO.inspect(Mod.function())

# List module
IO.puts(List)

alias Math.List, as: List

# List module from Math
IO.puts(List)

# This works because it takes the List as atom and that is a module in elixir
IO.puts("Takin Elixir.List as a atom: #{inspect(:"Elixir.List".flatten([1, [2], 3]))}")

# Module attributes -----------------------------

IO.puts("\nMODULE ATTRIBUTES:")

defmodule MyModule do
  @moduledoc """
    This is a test documentation for a module
  """

  @doc """
    This ia function that prints a string passed by parameter concatenated with " and something more"
  """

  @special_number 21

  Module.register_attribute(__MODULE__, :accumulated_param, accumulate: true)

  @accumulated_param 5

  @accumulated_param 65

  @accumulated_param 6

  def aFunction(something) do
    IO.puts(something)
    something <> " and something more"
  end

  def return_special_number do
    @special_number
  end

  def accumulated_param do
    IO.inspect(@accumulated_param)
  end

  def accumulated_param2 do
    IO.inspect(@accumulated_param)
  end
end

IO.puts(MyModule.aFunction("That"))
IO.puts("Special number: #{MyModule.return_special_number()}")

MyModule.accumulated_param()
MyModule.accumulated_param2()

# Structures -----------------------------

IO.puts("\nSTRUCTS:")

defmodule Person do
  # This key should be placed when creating a Person or it will raise an error
  @enforce_keys [:ID]
  defstruct [:ID, first_name: "Jhon", last_name: "Doe", age: 21, id: 1_234_567_890]
end

# From this and forward is gonna throw an error cause a struc can not be accessed in the same file
try do
  IO.puts("This part have a lot of lines of code market with ##,
but it can not be executed cause the struct Person can not be accessed
in the same context")

  ## %Person{}

  # Creating an structure
  ## person = %Person{first_name: "Cristhian", last_name: :Rodriguez, age: 25}

  # Accesing to a value
  # Strucs can not be accessed like a map, i.e. struc[:name], this gonna throw an error
  ## IO.puts(person.last_name)

  # Adding a new field
  # Strucs can not be enumerated like a map, i.e. Enum.each(struc, fn {field, value} -> IO.puts(value) end), gonna throw an error too
  # But it can use Map module functions
  ## person = Map.put(person, :have_a_cat, "No")
rescue
  e in CompileError ->
    IO.puts(
      "An error is catched here (cannot access struct Person, the struct was not yet defined)"
    )
end
