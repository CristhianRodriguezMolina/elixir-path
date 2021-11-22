defmodule MySigils do
  def sigil_d(string, []), do: String.to_integer(string)
  def sigil_d(string, [?d]), do: String.to_integer(string) * 2
  def sigil_d(string, [?t]), do: String.to_integer(string) * 3
  def sigil_d(string, [?c]), do: String.to_integer(string) * 4
end
