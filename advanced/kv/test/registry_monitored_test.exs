defmodule KV.RegistryMonitoredTest do
  use ExUnit.Case, async: true

  setup do
    registry = start_supervised!(KV.RegistryMonitored)
    %{registry: registry}
  end

  test "Testing the monitored feature of the RegistryMonitored", %{registry: registry} do
    KV.RegistryMonitored.create(registry, "shopping")
    {:ok, bucket} = KV.RegistryMonitored.lookup(registry, "shopping")
    Agent.stop(bucket)
    assert KV.RegistryMonitored.lookup(registry, "shopping") == :error
  end
end
