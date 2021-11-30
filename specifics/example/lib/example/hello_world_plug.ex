defmodule Example.HelloWorldPlug do
  import Plug.Conn

  # Initialize the plug options and it is called by a supervision tree
  def init(opts), do: opts

  # It receives a %Plug.Conn{} connection struct and returns a %Plug.Conn{} connection struct
  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello World!\n")
  end
end
