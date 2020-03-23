defmodule RankEm.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :other_names, {:array, :string}

      timestamps()
    end

  end
end
