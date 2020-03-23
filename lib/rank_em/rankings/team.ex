defmodule RankEm.Rankings.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :other_names, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :other_names])
    |> validate_required([:name, :other_names])
  end
end
