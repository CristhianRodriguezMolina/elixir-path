defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup do
    # This start_supervised method runs the KV.Registry start_link/1 method
    # This also guarantee that the registry process will be shutdown before the next test starts
    registry = start_supervised!(KV.Registry)
    %{registry: registry}
  end

  test "Testing buckets with GenServer", %{registry: registry} do
    # If the record doesnt exist then the Map.fetch/2 returns :error
    assert KV.Registry.lookup(registry, "shop") == :error

    # Creates a new registry and then search for it
    KV.Registry.create(registry, "shop")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shop")

    # After below, it uses KV.Bucket to put a value and get it
    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get_by_key(bucket, "milk") == 1
  end
end
