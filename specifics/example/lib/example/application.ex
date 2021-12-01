defmodule Example.Application do
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Example.Router, options: [port: cowboy_port()]}
    ]

    opts = [strategy: :one_for_one, name: Example.Supervisor]
    Logger.info("Starting application...")
    Supervisor.start_link(children, opts)
  end

  # Private function to get the application env variable
  # The third argument of get_env function is the default value if the directive is undefined
  defp cowboy_port, do: Application.get_env(:example, :cowboy_port, 8080)
end
