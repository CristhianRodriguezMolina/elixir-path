defmodule TestMod do
  require IEx

  def sum([a, b]) do
    b = 0
    # Works like a breakpoint
    IEx.pry()

    a + b
  end
end

IO.puts(TestMod.sum([34, 65]))
