defmodule Example.RouterTest do
  use ExUnit.Case
  use Plug.Test

  alias Example.Router

  # Test fields for the router
  @content "<html><body>Hi!</body></html>"
  @mimetype "test/html"

  # Test options for the router
  @opts Router.init([])

  test "return welcome" do
    # Request
    conn =
      :get
      |> conn("/", "")
      |> Router.call(@opts)

    # Response of the request
    assert conn.state == :sent
    assert conn.status == 200
  end

  test "return uploaded" do
    # Request
    conn =
      :get
      |> conn("/upload?content=#{@content}&mimetype=#{@mimetype}")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 201
  end

  test "return 404" do
    # Request
    conn =
      :get
      |> conn("/missing", "")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end
end
