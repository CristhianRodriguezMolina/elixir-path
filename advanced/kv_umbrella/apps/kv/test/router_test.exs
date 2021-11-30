defmodule KV.RouterTest do
  use ExUnit.Case

  # This setup runs after all the test in the file
  setup_all do
    # Getting the current state of the env variable `:routing_table`
    current = Application.get_env(:kv, :routing_table)

    Application.put_env(:kv, :routing_table, [
      {?a..?m, :"foo@cristh-MS-7B85"},
      {?n..?z, :"bar@cristh-MS-7B85"}
    ])

    # Setting back the real value of `:routing_table` on exit
    on_exit(fn -> Application.put_env(:kv, :routing_table, current) end)
  end

  @tag :distributed
  test "route requests across nodes" do
    assert KV.Router.route("hello", Kernel, :node, []) ==
             :"foo@cristh-MS-7B85"

    assert KV.Router.route("world", Kernel, :node, []) ==
             :"bar@cristh-MS-7B85"
  end

  test "raises on unknown entries" do
    assert_raise RuntimeError, ~r/could not find entry/, fn ->
      KV.Router.route(<<0>>, Kernel, :node, [])
    end
  end
end
