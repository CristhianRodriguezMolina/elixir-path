defmodule KVServerTest do
  use ExUnit.Case

  # To capture the logs in the whole module test
  @moduletag :capture_log

  # Restart the aplication :kv
  setup do
    Application.stop(:kv)
    :ok = Application.start(:kv)
  end

  setup do
    opts = [:binary, packet: :line, active: false]
    # This connects to the server in the port 4040
    {:ok, socket} = :gen_tcp.connect('localhost', 4040, opts)
    %{socket: socket}
  end

  test "server interaction", %{socket: socket} do
    assert send_and_recv(socket, "UNKNOWN shopping\r\n") == "UNKNOWN COMMAND\r\n"

    assert send_and_recv(socket, "GET shopping eggs\r\n") == "NOT FOUND\r\n"

    assert send_and_recv(socket, "CREATE shop\r\n") == "OK\r\n"

    assert send_and_recv(socket, "CREATE new\r\n") == "OK\r\n"

    assert send_and_recv(socket, "PUT shop sugar 5kg\r\n") == "OK\r\n"

    assert send_and_recv(socket, "GET shop sugar\r\n") == "5kg\r\n"

    assert send_and_recv(socket, "") == "OK\r\n"

    assert send_and_recv(socket, "DELETE shop sugar\r\n") == "OK\r\n"

    assert send_and_recv(socket, "GET shop eggs\r\n") == "\r\n"
  end

  # Method to send and receive messages working as a client
  defp send_and_recv(socket, command) do
    :ok = :gen_tcp.send(socket, command)
    # Receiving data with a timeout of 1 second
    {:ok, data} = :gen_tcp.recv(socket, 0, 1000)
    data
  end
end
