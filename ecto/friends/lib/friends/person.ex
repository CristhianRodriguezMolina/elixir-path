defmodule Friends.Person do
  use Ecto.Schema
  import Ecto.Changeset

  # We're saying to ecto that this schema relates to `people` table
  schema "people" do
    field(:name, :string)
    field(:age, :integer, default: 0)
  end

  @doc """
  Testing some of the validations for changesets
  """
  def test_changeset(struct, params) do
    struct
    # Fields allowed to go through and be modified
    |> cast(params, [:name, :age])
    # ensures age is included in the range 0 to 99 (enumerable)
    |> validate_inclusion(:age, 0..99)
    |> validate_exclusion(:name, ~w(max ben))
    # ensures that the name is always required
    |> validate_required([:name])
    # ensures that the name length is always above 2
    |> validate_length(:name, min: 4)
    |> validate_fictional_name()
  end

  @doc """
  Registration changeset to Person
  """
  def registration_changeset(struct, params) do
    struct
    |> cast(params, [:name, :age])
    # Setting name to `Anonymous` if there is no name
    |> set_name_if_anonymous()
  end

  # Names to validate
  @fictional_names ["Spiderman", "Superman"]
  @doc """
  Custom validation for a Person name
  """
  def validate_fictional_name(changeset) do
    # Get the name field from the changeset
    name = get_field(changeset, :name)

    if name in @fictional_names do
      changeset
    else
      # Adding an error to the changeset
      add_error(changeset, :name, "Is not a superhero")
    end
  end

  @doc """
  Set the name of a changeset to `Anonymous` if there is not name
  """
  def set_name_if_anonymous(changeset) do
    name = get_field(changeset, :name)

    if is_nil(name) do
      put_change(changeset, :name, "Anonymous")
    else
      changeset
    end
  end

  @doc """
  Sign up for Person keeping in mind the registration_changeset
  """
  def sign_up(params) do
    %Friends.Person{}
    |> Friends.Person.registration_changeset(params)
    |> Friends.Repo.insert()
  end
end
