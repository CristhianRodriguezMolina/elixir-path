IO.puts("Hello world from Elixir")

# Este es un comentario en Elixir

# String
IO.puts("\nSTRING:")

x = "hello" <> "\n#{:world}"

IO.puts(x)
IO.puts("hello...>world")

IO.puts(byte_size("Hello"))
IO.puts(byte_size("Hello@"))
IO.puts(byte_size("Hell%"))

# Functions
IO.puts("\nFUNCTIONS:")

subs = fn a, b -> a - b end

IO.puts(subs.(1, 2))
IO.puts(!is_function(subs))

# Lists
IO.puts("\nLISTS")

listPlus = [1, 2, 3, 1, 1] ++ [1, 3, 4]
listMinos = [1, 2, 3, 1, 1] -- [1]
listCharacters = [104, 101, 108, 108, 111]

IO.inspect(listPlus, label: "Plus plus test")
IO.inspect(listMinos, label: "Minos minos test")
IO.inspect(listCharacters, label: "List with character codes")
IO.inspect([4, 5, 6], label: "A list")
IO.puts(length([4, 5, 6]))

IO.inspect(hd(listPlus),
  label: "Head test of [#{Enum.join(listPlus, ", ")}]"
)

IO.inspect(tl(listPlus),
  label: "Tail test of [#{Enum.join(listPlus, ", ")}]"
)

IO.puts("Test printing a list with puts #{inspect(listMinos)}")

# Object test

IO.inspect(%{x: 1} == %{x: 1}, label: "Tuple double equals")

# Operators

IO.puts("Testing type compare tuple < atom: #{{1, 2} < :world}")
IO.puts("Testing type compare tuple < bitstring: #{{1, 2} < 'hi'}")

IO.puts(0 === 0.0)
