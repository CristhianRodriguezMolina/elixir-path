# Deconstruction -----------------------------

{a, b, c, d} = {:world, [1, 2, 3], 'car', 4.5}

IO.puts("#{a} #{inspect(b)} #{c} #{d}")

[r, f, g] = [1, :hi, 3]

IO.puts("#{r} #{f} #{g}")

[head | tail] = [1, :hi, 3]

IO.puts(inspect([head | tail]))

[_ | tail] = [1, :hi, 3]

IO.puts(inspect(tail))

# Pin operator -----------------------------

x = :s

[^x, 2, 3] = [:s, 2, 3]

IO.puts(x)

:s = x

{:ok, result} = {:ok, {:day, 'baby'}}

IO.puts(inspect(result))

# Case -----------------------------

{x, y, z} = {1, 2, 15}

case 15 do
  ^x -> IO.puts("case 1")
  # Enters here because the variables can be rebound
  y -> IO.puts("case 2")
  ^z -> IO.puts("case 3")
  _ -> IO.puts("default")
end

case {1, 2, 3} do
  {1, x, 3} when x > 0 ->
    IO.puts("Hello")

  _ ->
    IO.puts("Default")
end

# Case with functions -----------------------------

# fun = fn
#   a, b when a > b -> a * b    THIS HAS AN ERROR CAUSE IF a AND b ARE EQUALS THERE IS NO CLAUSE
#   a, b when a < b -> a / b
# end

# fun = fn
#   a, b when a > b -> a * b    THIS HAS AN ERROR CAUSE YOU CANT MIX CLAUSES WITH DIFFERENT ARIETIES
#   a, b when a < b -> a / b
#   _ -> a
# end

fun = fn
  a, b when a == b -> a * b
  a, b when a != b -> a / b
  a, b -> a
end

IO.puts(fun.(2, 2))
IO.puts(fun.(3, 4))

#  Cond -----------------------------

# z equals 16 after this
z =
  cond do
    x > z ->
      IO.puts("Cond 1")

    z == y ->
      IO.puts("Cond 2")

    true ->
      z = z + 1
  end

cond do
  # Here every value besides false or nil will be true
  z ->
    IO.puts("Why?")
end

# if unless -----------------------------

v = 5

# Result is z = 17, v = 7
{v, z} =
  if v > 3 do
    v = v + 1
    v = v + 1
    z = z + 1
    {v, z}
  end

IO.puts("Prueba if: #{z} #{v}")

# Result is 7

IO.puts("if result v #{v}")
IO.puts("if result z #{z}")

unless true, do: IO.puts("Esto no se ejecuta")

# Binaries, strings and charlists -----------------------------

IO.puts("Is binary/1 with car: #{is_binary("car")}")

IO.puts("Code point of \"%\" is #{?%}")

s = "This is á cár ꜳ é"

IO.puts("Count of graphemes: #{String.length(s)}")

# á has two code poinst
IO.puts("Count of code points: #{length(String.to_charlist(s))} #{String.to_charlist(s)}")

IO.puts("Byte size: #{byte_size(s)}")

# Binaries

IO.inspect(s, binaries: :as_binaries)

IO.inspect(<<45::6>>, binaries: :as_binaries)

# 257 represented in 8 bits is 00000001, so its equals to 1
IO.puts(<<1>> === <<257>>)

<<head::binary-size(2), rest::binary>> = <<0, 1, 2, 3>>

# Like head and tail in lists
IO.puts(inspect(head))
IO.puts(inspect(rest))

IO.puts(
  "Only if the binary is valid given the UTF-8 standard rules (Valid in <<239, 191, 19>>): #{String.valid?(<<239, 191, 19>>)}"
)

<<head::utf8, rest::binary>> = "banana"

IO.puts(to_string([head]))
IO.puts(rest)

# Charlists

IO.puts([104, 101, 322, 322, 111])
IO.puts(inspect(to_charlist(s)))
IO.puts(to_string([42803]))

IO.puts(
  to_string(
    <<84, 104, 105, 115, 32, 105, 115, 32, 195, 161, 32, 99, 195, 161, 114, 32, 234, 156, 179, 32,
      195, 169>>
  )
)
