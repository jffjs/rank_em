defmodule RankEm.Rankings.League do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leagues" do
    field :long_name, :string
    field :name, :string
    field :sport, :string

    timestamps()
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, [:name, :long_name, :sport])
    |> validate_required([:name, :long_name, :sport])
  end
end
