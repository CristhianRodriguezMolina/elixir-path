defmodule Example.Plug.VerifyRequest do
  defmodule IncompleteRequestError do
    @moduledoc """
    Error raised when a required field is missing
    """

    defexception message: "", plug_status: 400
  end

  # Initialize the plug options and it is called by a supervision tree
  def init(opts), do: opts

  # It receives a %Plug.Conn{} connection struct and returns a %Plug.Conn{} connection struct
  # Only if the request path is contained in our `:paths` then it calls `verify_request!/2`
  @doc false
  def call(%Plug.Conn{request_path: path} = conn, opts) do
    if path in opts[:paths], do: verify_request!(conn.params, opts[:fields])
    conn
  end

  # It verifies if all the requiered `:fields` are in the request, otherwise raise `IncompleteRequestError`
  defp verify_request!(params, fields) do
    verified =
      params
      |> Map.keys()
      |> contains_fields?(fields)

    unless verified, do: raise(IncompleteRequestError)
  end

  # Return true if all of the fields are in keys
  defp contains_fields?(keys, fields), do: Enum.all?(fields, &(&1 in keys))
end
