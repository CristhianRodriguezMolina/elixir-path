defmodule KV do
  use Application

  @moduledoc """
  Documentation for `KV`.
  """

  @doc """
    start/2 from the Application module

    It starts the supervision tree
  """
  @impl true
  def start(_type, _args) do
    KV.Supervisor.start_link(name: KV.Supervisor)
  end
end
