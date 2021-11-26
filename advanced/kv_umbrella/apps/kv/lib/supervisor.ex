defmodule KV.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      # Inititializating the DynamicSupervisor for buckets
      # We should place the BucketSupervisor before the Registry cause it invokes the BucketSupervisor
      # The strategy :one_for_one means that if a child in the supervisor dies it will be the only one restarted
      {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one},
      {KV.Registry, name: KV.Registry}
    ]

    # The strategy :one_for_all means that if a child dies the supervisor will kill and restart all of its childs
    # This opcion will call the start_link implemetation of KV.Registry with the parameter "name: KV.Registry"
    Supervisor.init(children, strategy: :one_for_all)
  end
end
