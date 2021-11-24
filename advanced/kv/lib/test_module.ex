defmodule TestModule do
  @spec print_after_timeout(String.t(), integer()) :: String.t()
  def print_after_timeout(string, time) do
    Process.sleep(time)
    IO.puts(string)
  end
end
