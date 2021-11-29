defmodule Friends.Actor do
  use Ecto.Schema

  schema "actors" do
    field(:name, :string)

    # Connection between actors and movies
    many_to_many(:movies, Friends.Movie, join_through: "movies_actors")
  end
end
