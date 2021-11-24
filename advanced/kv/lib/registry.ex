defmodule KV.Registry do
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

  @typedoc """
    This receives the second argument of the GenServer.start_link/3 below

    returns
    - :ok, to reply to the client
    - state, the initialization state
  """
  @impl true
  def init(:ok) do
    # {:ok, state}
    {:ok, %{}}
  end

  @typedoc """
    Returns
    - :reply, to say that the server should reply to client
    - reply, is what will be sent to the client
    - new_state, is the new server state
  """
  @impl true
  def handle_call({:lookup, name}, _from, names) do
    # {:reply, reply, new_state}
    {:reply, Map.fetch(names, name), names}
  end

  @impl true
  def handle_cast({:create, name}, names) do
    if Map.has_key?(names, name) do
      {:noreply, names}
    else
      {:ok, bucket} = KV.Bucket.start_link([])
      {:noreply, Map.put(names, name, bucket)}
    end
  end
end
