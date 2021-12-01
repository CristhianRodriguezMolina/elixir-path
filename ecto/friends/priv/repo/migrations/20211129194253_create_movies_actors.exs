defmodule Friends.Repo.Migrations.CreateMoviesActors do
  use Ecto.Migration

  def change do
    create table(:movies_actors) do
      # Two foreing keys actors and movies
      add(:movie_id, references(:movies))
      add(:actor_id, references(:actors))
    end

    # Enforce unique pairings of actors and movies
    create(unique_index(:movies_actors, [:movie_id, :actor_id]))
  end
end
