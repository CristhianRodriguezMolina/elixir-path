defmodule ExampleTest do
  use ExUnit.Case
  doctest Example

  test "greets the world" do
    assert Example.greeting("Cristh") == "Hi, Cristh"
  end
end
