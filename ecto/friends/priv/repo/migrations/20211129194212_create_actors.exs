defmodule Friends.Repo.Migrations.CreateActors do
  use Ecto.Migration

  def change do
    create table(:actors) do
      # Fields in the database table
      add(:name, :string)
    end
  end
end
