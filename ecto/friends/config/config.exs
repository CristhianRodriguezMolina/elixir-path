import Config

# This allows esto to run exto mix commands from the commandline
config :friends, ecto_repos: [Friends.Repo]

# Configuration of the database including the adapter to use
config :friends, Friends.Repo,
  database: "friends_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
