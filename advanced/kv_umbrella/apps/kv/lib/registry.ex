defmodule KV.Registry do
  # GenServer Behaviour
  use GenServer

  # CLIENT PART

  @doc """
  The "__MODULE__" means that the module where the server callbacks are implemented,
  in this case is the current module

  Now the `:name` is always require
  """
  def start_link(opts) do
    # Adding ETS #1: Pass the name to GenServer's init
    server = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, server, opts)
  end

  @doc """
  Looks up the bucket pid

  Returns `{:ok, PID}` if the bucket exists, :error otherwise
  """
  def lookup(server, name) do
    # Adding ETS #2: Lookup is now done directly in ETS, without accessing the server
    case :ets.lookup(server, name) do
      # The `^` is to force the name to be equals to the provided
      [{^name, pid}] -> {:ok, pid}
      [] -> :error
    end
  end

  # @doc """
  # Looks up for all the buckets

  # Returns %{name => PID, ...}
  # """

  # def lookup(server) do
  #   GenServer.call(server, :get_all)
  # end

  @doc """
  Creates a new bucket in the `server` with the given `name` if it doesnt exist
  """
  def create(server, name) do
    GenServer.call(server, {:create, name})
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
  def init(table) do
    # Adding ETS #3: We have replaced the names map by the ETS table
    names = :ets.new(table, [:named_table, read_concurrency: true])
    refs = %{}
    # {:ok, state}, the state now is a tuple of refs and the names
    {:ok, {names, refs}}
  end

  # Adding ETS #4: The previous handle_call callbacks for lookup was removed

  @impl true
  def handle_call({:create, name}, _from, {names, refs}) do
    case lookup(names, name) do
      {:ok, pid} ->
        # Changing this from {:noreply, {names, refs}} to:
        {:reply, pid, {names, refs}}

      :error ->
        # With this every bucket starts with the DynamicSupervisor
        {:ok, bucket} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
        # To create a new ref we start monitor on the new bucket
        ref = Process.monitor(bucket)
        # Then we save it in the refs state
        refs = Map.put(refs, ref, name)
        # And the name and the new bucket (`{name, pid}`) in the `names` ets
        :ets.insert(names, {name, bucket})
        # Changing this from {:noreply, {names, refs}} to:
        {:reply, bucket, {names, refs}}
    end
  end

  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    :ets.delete(names, name)
    {:noreply, {names, refs}}
  end

  @impl true
  def handle_info(msg, state) do
    require Logger
    Logger.debug("Unexpected message in KV.Registry: #{inspect(msg)}")
    {:noreply, state}
  end
end
