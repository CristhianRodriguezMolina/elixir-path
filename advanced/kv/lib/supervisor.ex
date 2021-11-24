defmodule KV.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {KV.Registry, name: KV.Registry},
      # Inititializating the DynamicSupervisor for buckets
      {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one}
    ]

    # The strategy :one_for_one means that if a child in the supervisor dies it will be the only one restarted
    # This opcion will call the start_link implemetation of KV.Registry with the parameter "name: KV.Registry"
    Supervisor.init(children, strategy: :one_for_one)
  end
end
