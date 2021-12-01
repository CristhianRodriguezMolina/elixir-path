defmodule Example do
  require EEx

  # Compiling a eex file
  EEx.function_from_file(:def, :greeting, "lib/greeting.eex", [:name])

  def cpu_burns(a, b, c) do
    x = a * 2
    y = b * 3
    z = c * 5

    x + y + z
  end

  @spec sum_times(integer) :: integer
  def sum_times(a) do
    [1, 2, 3]
    |> Enum.map(fn el -> el * a end)
    |> Enum.sum()
    |> round
  end
end
