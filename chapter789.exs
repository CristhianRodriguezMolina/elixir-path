# Keyword lists and maps -----------------------------

keywordlist = [a: 1, b: 2, a: 3]

IO.puts("Keyword list: #{inspect(keywordlist)}")

IO.puts("Keyword list at a: #{keywordlist[:a]}")

[a: x, b: y, a: z] = keywordlist

IO.puts(inspect([x, y, z]))

# Maps

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
