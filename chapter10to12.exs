# Enum -----------------------------

IO.puts("ENUM:")

IO.puts(inspect(Enum.map([1, 2, 3], fn x -> x * 2 end)))

range = Enum.map(1..10, fn x -> x + x end)

IO.puts("Ranges 1..10: #{inspect(range)}")

range = List.insert_at(range, 10, 22)

IO.puts("Inserting 22 in pos 10: #{inspect(range)}")

# Pipeline of operations -----------------------------

IO.puts("\nPIPELINE OF OPERATIONS:")

# The "?" indicates that this function returns a bool
odd? = &(rem(&1, 2) != 0)

# The operator |> is a pipe that pass the result of the left side to the right side function in the first argument
pipe = 1..100_000 |> Enum.map(&(&1 * 3)) |> Enum.filter(odd?) |> Enum.sum()

# 7500000000
IO.puts(pipe)

# Streams -----------------------------

IO.puts("\nSTREAMS:")

# A type of Enum specialy for pipes cause it doesnt create a intermediate list but a series of computations
stream = 1..100_000 |> Stream.map(&(&1 * 3)) |> Stream.filter(odd?) |> Enum.sum()

# 7500000000
IO.puts(stream)

# cycle is a stream that cycles a given enumerable forever
IO.puts("Stream cycle: " <> to_string(inspect(Enum.take(Stream.cycle([1, 2, 3, 4]), 15))))

unfoldTest = Stream.unfold("Eurotruck", &String.next_codepoint/1)

IO.puts(Enum.take(unfoldTest, 5))

IO.puts("\nExample with file stream:")

fileStream = File.stream!("./textFile.txt")

IO.puts(inspect(Enum.take(fileStream, 15)))

# Process -----------------------------

IO.puts("\nPROCESSES:")

pid = spawn(fn -> 1 + 2 end)

IO.puts(inspect(pid))
IO.puts(Process.alive?(pid))

IO.inspect(self(), binaries: :as_binaries)

task =
  Task.async(fn ->
    # This timeout is to excecute the next lines
    :timer.sleep(1000)
    IO.puts("Bro")
  end)

# This timeout is to wait the execution of the task
Task.await(task, 5000)

# After this every line executes after 2 seconds
IO.puts("After error")

defmodule KV do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send(caller, Map.get(map, key))
        loop(map)

      {:put, key, value} ->
        loop(Map.put(map, key, value))
    end
  end
end

{:ok, pid} = KV.start_link()

IO.puts(inspect(pid))

Process.register(pid, :kv)

# IO and the file system -----------------------------

input = IO.gets("Write a number: ")

IO.puts("The double of the input number is: #{String.to_integer(String.trim(input), 10) * 2}")

# File

IO.puts("\nFILE:")

testFile = File.read("textFile.txt")

IO.inspect(testFile)

errorFile = File.read("testFile")

# Verifying if error with "if"
if elem(errorFile, 0) == :error do
  IO.puts("The file doesnt exist")
else
  IO.puts("All right")
end

defmodule VerifyFile do
  def fileExists(file) do
    case File.read(file) do
      {:ok, content} ->
        IO.puts("All right: #{inspect(content)}")

      {:error, reason} ->
        IO.puts("Error reading file: #{reason}")
    end
  end
end

# Verifying if error with "case"
VerifyFile.fileExists("textFile.txt")
VerifyFile.fileExists("textFile")

# This kind of expression is to receive a tuple like this: {:ok, content} or {:error, reason}
auxFile = File.read("textFile.txt")
# This kind of expression is to receive the message directly
auxFile = File.read!("textFile.txt")

# Path

IO.puts("\nPATH:")

IO.puts(Path.expand("~/"))

{:ok, file} = File.open("textFile.txt", [:write])

IO.puts("Reading the filewith File.open: #{inspect(file)}")

IO.inspect(File.write("textFile.txt", "Hello", [:append]))
