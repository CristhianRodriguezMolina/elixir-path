defmodule KVServer do
  require Logger

  @moduledoc """
  Documentation for `KVServer`.
  """

  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    # We start a serve task with the Task Supervisor
    {:ok, pid} = Task.Supervisor.start_child(KVServer.TaskSupervisor, fn -> serve(client) end)

    # Without this the acceptor will bring down all the clients if it crashed (Like when quitting a client)
    :ok = :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  # This method reads a line from the socket and then replies the same line to the socket
  defp serve(socket) do
    # Firstly we read the line from the socket
    # msg =
    #   case read_line(socket) do
    #     # If it is a good message enters here
    #     {:ok, data} ->
    #       # Then tries to parse the message from the socket
    #       case KVServer.Command.parse(data) do
    #         # If it is a parseable command enters here
    #         {:ok, command} ->
    #           # And then runs the command
    #           KVServer.Command.run(command)

    #         # If there is an error enters here
    #         {:error, _} = err ->
    #           err
    #       end

    #     # If there is an error enters here
    #     {:error, _} = err ->
    #       err
    #   end

    # This code does the same like above, but more compact (Like pipelines)
    msg =
      with {:ok, data} <- read_line(socket),
           {:ok, command} <- KVServer.Command.parse(data),
           do: KVServer.Command.run(command, KV.Registry)

    IO.inspect(msg)

    write_line(socket, msg)
    serve(socket)
  end

  defp read_line(socket) do
    :gen_tcp.recv(socket, 0)
  end

  defp write_line(socket, {:ok, text}) do
    :gen_tcp.send(socket, text)
  end

  defp write_line(socket, {:error, :not_found}) do
    # Known error (Error in a command); write to the client
    :gen_tcp.send(socket, "NOT FOUND\r\n")
  end

  defp write_line(socket, {:error, :unknown_command}) do
    # Known error (Unknown command); write to the client
    :gen_tcp.send(socket, "UNKNOWN COMMAND\r\n")
  end

  defp write_line(_socket, {:error, :closed}) do
    # The connection was closed, exit politely
    exit(:shutdown)
  end

  defp write_line(socket, {:error, error}) do
    # Unknown error; write to the client and exit
    :gen_tcp.send(socket, "ERROR\r\n")
    exit(error)
  end
end
