defmodule RankEm.Rankings.Conference do
  use Ecto.Schema
  import Ecto.Changeset

  schema "conferences" do
    field :name, :string
    field :other_names, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(conference, attrs) do
    conference
    |> cast(attrs, [:name, :other_names])
    |> validate_required([:name, :other_names])
  end
end
