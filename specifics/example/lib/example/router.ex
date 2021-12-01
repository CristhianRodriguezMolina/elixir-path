defmodule Example.Router do
  use Plug.Router
  # Plug Error Handler
  use Plug.ErrorHandler

  # Importing the plug to the router
  alias Example.Plug.VerifyRequest

  plug(Plug.Parsers, parsers: [:urlencoded, :multipart])

  # Plug configuration for the router
  plug(VerifyRequest, fields: ["content", "mimetype"], paths: ["/upload"])

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  get "/upload" do
    send_resp(conn, 201, "Uploaded")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end

  # This function is called when an error is raised
  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stack}) do
    IO.inspect(kind, label: :kind)
    IO.inspect(reason, label: :reason)
    IO.inspect(stack, label: :stack)
    # Response to the user when something go wrong (example, `/upload` route without fields)
    send_resp(conn, conn.status, "Something went wrong!!!")
  end
end
