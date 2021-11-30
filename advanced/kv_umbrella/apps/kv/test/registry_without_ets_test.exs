defmodule KV.RegistryWithoutETSTest do
  use ExUnit.Case, async: true

  setup do
    # This is accessing to a non-shared partition of the state of KV.RegistryWithoutETS
    registry = start_supervised!(KV.RegistryWithoutETS)
    %{registry: registry}
  end

  test "Testing the monitored feature of the RegistryMonitored", %{registry: registry} do
    KV.RegistryWithoutETS.create(registry, "shopping")
    {:ok, bucket} = KV.RegistryWithoutETS.lookup(registry, "shopping")
    Agent.stop(bucket)
    assert KV.RegistryWithoutETS.lookup(registry, "shopping") == :error
  end

  test "Testing buckets with GenServer", %{registry: registry} do
    # If the record doesnt exist then the Map.fetch/2 returns :error
    assert KV.RegistryWithoutETS.lookup(registry, "shop") == :error

    # Creates a new registry and then search for it
    KV.RegistryWithoutETS.create(registry, "shop")
    assert {:ok, bucket} = KV.RegistryWithoutETS.lookup(registry, "shop")

    # After below, it uses KV.Bucket to put a value and get it
    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes bucket on crash", %{registry: registry} do
    KV.RegistryWithoutETS.create(registry, "shopping")
    {:ok, bucket} = KV.RegistryWithoutETS.lookup(registry, "shopping")

    # Stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)
    assert KV.RegistryWithoutETS.lookup(registry, "shopping") == :error
  end
end
