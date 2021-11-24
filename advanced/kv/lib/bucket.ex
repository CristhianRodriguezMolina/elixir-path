defmodule KV.Bucket do
  use Agent

  @typedoc """
    Everything in the funcion of an agent is considered the Server

    And everything outside is considered the Client
  """

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end)
  end

  def get_by_key(bucket, key) do
    Agent.get(bucket, fn content -> Map.get(content, key) end)
  end

  def get(bucket) do
    Agent.get(bucket, & &1)
  end

  def put(bucket, key, value) do
    Agent.update(bucket, fn content -> Map.put(content, key, value) end)
  end

  def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
  end
end
