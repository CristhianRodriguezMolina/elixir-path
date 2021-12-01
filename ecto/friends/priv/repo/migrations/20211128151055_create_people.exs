defmodule Friends.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    # Creating a table with ecto migrations
    create table(:people) do
      add(:name, :string, null: false)
      add(:age, :integer, default: 0)
    end
  end
end
