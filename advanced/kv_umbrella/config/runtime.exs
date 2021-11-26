# This is a file for in runtime configurations

import Config

# Configuring the enviroment variable `:routing_table`
config :kv, :routing_table, [{?a..?z, node()}]

# This configuration applies only for production enviroment
if config_env() == :prod do
  config :kv, :routing_table, [
    {?a..?m, :"foo@cristh-MS-7B85"},
    {?n..?z, :"bar@cristh-MS-7B85"}
  ]
end
