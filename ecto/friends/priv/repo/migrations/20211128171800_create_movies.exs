defmodule Friends.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    create table(:movies) do
      # Fields in the database table
      add(:title, :string)
      add(:tagline, :string)
    end
  end
end
