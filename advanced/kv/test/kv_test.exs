defmodule KVTest do
  use ExUnit.Case
  doctest KV

  test "greets the world" do
    assert KV.hello() == :world
  end

  test "failing sum on purpose" do
    assert KV.sum(3, 4) == 7
  end
end
