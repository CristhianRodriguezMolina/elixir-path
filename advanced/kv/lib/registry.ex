defmodule KV.Registry do
  # GenServer Behaviour
  use GenServer

  # CLIENT PART

  # The "__MODULE__" means that the module where the server callbacks are implemented,
  # in this case is the current module
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  # SERVER PART

  # The "@impl true" means that the function below is a callback
  # The functions implemented should be functions that

  @doc """
    This receives the second argument of the GenServer.start_link/3 below

    returns
    - :ok, to reply to the client
    - state, the initialization state
  """
  @impl true
  def init(:ok) do
    names = %{}
    refs = %{}
    # {:ok, state}, the state now is a tuple of refs and the names
    {:ok, {names, refs}}
  end

  @doc """
    Returns
    - :reply, to say that the server should reply to client
    - reply, is what will be sent to the client
    - new_state, is the new server state
  """
  @impl true
  def handle_call({:lookup, name}, _from, state) do
    # We get just the names of the state to search for the name
    {names, _} = state
    # {:reply, reply, new_state}
    {:reply, Map.fetch(names, name), state}
  end

  @impl true
  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      # With this every bucket starts with the DynamicSupervisor
      {:ok, bucket} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
      # To create a new ref we start monitor on the new bucket
      ref = Process.monitor(bucket)
      # Then we save it in the refs state
      refs = Map.put(refs, ref, name)
      # And the name of the new bucket in the names state
      names = Map.put(names, name, bucket)
      {:noreply, {names, refs}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  @impl true
  def handle_info(msg, state) do
    require Logger
    Logger.debug("Unexpected message in KV.Registry: #{inspect(msg)}")
    {:noreply, state}
  end
end
