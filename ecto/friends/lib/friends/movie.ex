defmodule Friends.Movie do
  use Ecto.Schema

  schema "movies" do
    field(:title, :string)
    field(:tagline, :string)

    # This doesnt add anything to the database, it uses the key on the associated schema `characters`
    has_many(:characters, Friends.Character)

    # This allow us to call movie.distributor
    has_one(:distributor, Friends.Distributor)

    # Connection between actors and movies
    many_to_many(:actors, Friends.Actor, join_through: "movies_actors")
  end
end
