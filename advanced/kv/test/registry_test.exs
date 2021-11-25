defmodule KV.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    # This is accessing to a non-shared partition of the state of KV.Registry
    _ = start_supervised!({KV.Registry, name: context.test})
    %{registry: context.test}
  end

  test "Testing the monitored feature of the RegistryMonitored", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)

    # This request is a synchronous request
    # that ensures that the registry processed the DOWN message
    _ = KV.Registry.create(registry, "bogus")
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "Testing buckets with GenServer", %{registry: registry} do
    # If the record doesnt exist then the Map.fetch/2 returns :error
    assert KV.Registry.lookup(registry, "shop") == :error

    # Creates a new registry and then search for it
    KV.Registry.create(registry, "shop")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shop")

    # After below, it uses KV.Bucket to put a value and get it
    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "removes bucket on crash", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # Stop the bucket with non-normal reason
    Agent.stop(bucket, :shutdown)

    # Now trying to call the dead process causes a :noproc exit
    catch_exit(KV.Bucket.put(bucket, "milk", 3))

    # This request is a synchronous request
    # that ensures that the registry processed the DOWN message
    _ = KV.Registry.create(registry, "bogus")
    assert KV.Registry.lookup(registry, "shopping") == :error
  end
end
